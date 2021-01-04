import Foundation
import Carbon

class HotKeyController {
    
    private static let eventSignature = fourCharCodeFrom("SWAT")
    
    private var subscribedKeys = [KeyScheme:EventHotKeyRef?]()
    
    private var keyIds = [UInt32:KeyScheme]()
    private var idsToKeys = [KeyScheme:UInt32]()
    
    private var eventHandlerRef: EventHandlerRef?
    
    private static func fourCharCodeFrom(_ string: String) -> FourCharCode
    {
      assert(string.count == 4, "String length must be 4")
      var result : FourCharCode = 0
      for char in string.utf16 {
        result = (result << 8) + FourCharCode(char)
      }
      return result
    }
 
    public func register(keyScheme: KeyScheme) {
        if subscribedKeys[keyScheme] != nil {
            return
        }
        
        var eventHotKey: EventHotKeyRef?
        let hotKeyID = EventHotKeyID(signature: HotKeyController.eventSignature, id: generateNextId())
        
        let registerError = RegisterEventHotKey(
            keyScheme.getCarbonCode(),
            keyScheme.getCarbonModifierd(),
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &eventHotKey
        )
        
        guard registerError == noErr, eventHotKey != nil else {
            return
        }
        
        subscribedKeys[keyScheme] = eventHotKey
        keyIds[hotKeyID.id] = keyScheme
        idsToKeys[keyScheme] = hotKeyID.id

        updateEventHandler()
    }
    
    public func unregister(keyScheme: KeyScheme) {
        guard let keySchemeRef = subscribedKeys[keyScheme] else {
            return
        }

        subscribedKeys.removeValue(forKey: keyScheme)
        let id = idsToKeys[keyScheme]
        idsToKeys.removeValue(forKey: keyScheme)
        keyIds.removeValue(forKey: id!)
        
        UnregisterEventHotKey(keySchemeRef)
    }
    
    func onHotKeyEvent(event: EventRef?) -> OSStatus {
        guard let event = event else {
            return OSStatus(eventNotHandledErr)
        }

        // Get the hot key ID from the event
        var hotKeyID = EventHotKeyID()
        let error = GetEventParameter(
            event,
            UInt32(kEventParamDirectObject),
            UInt32(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )

        if error != noErr {
            return error
        }

        // Ensure we have a HotKey registered for this ID
        guard hotKeyID.signature == HotKeyController.eventSignature,
              let hotKey = keyIds[hotKeyID.id]
        else {
            return OSStatus(eventNotHandledErr)
        }

        // Call the handler
        switch GetEventKind(event) {
        case UInt32(kEventHotKeyPressed):
            if let listener = hotKey.onKeyDownListener {
                listener()
                return noErr
            }
        case UInt32(kEventHotKeyReleased):
            if let listener = hotKey.onKeyUpListener {
                listener()
                return noErr
            }
        default:
            break
        }

        return OSStatus(eventNotHandledErr)
    }

    
    private func updateEventHandler() {
        let eventSpec = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed)),
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased))
        ]
        
        //TODO(st235): check retain references
        let rawSelf = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())

        InstallEventHandler(GetEventDispatcherTarget(), { (_, eventRef, userData) in
            guard let userData = userData else {
                return OSStatus(eventNotHandledErr)
            }
            
            let unwrappedSelf = Unmanaged<HotKeyController>.fromOpaque(userData).takeUnretainedValue()
            return unwrappedSelf.onHotKeyEvent(event: eventRef)
        }, 2, eventSpec, rawSelf, &eventHandlerRef)
    }
    
    private func generateNextId() -> UInt32 {
        return UInt32(subscribedKeys.values.count + 1)
    }
    
}
