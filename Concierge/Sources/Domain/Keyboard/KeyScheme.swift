import AppKit
import Carbon

class KeyScheme {
    
    public typealias Listener = () -> Void
    
    private let key: Key
    private let carbonModifiers: UInt32
    
    public var onKeyDownListener: Listener?
    public var onKeyUpListener: Listener?
    
    init(key: Key, modifiers: NSEvent.ModifierFlags) {
        self.key = key
        self.carbonModifiers = modifiers.carbonValue
    }
    
    public func getCarbonCode() -> UInt32 {
        return key.carbonKeyCode
    }
    
    public func getCarbonModifierd() -> UInt32 {
        return carbonModifiers
    }
    
}

extension KeyScheme: Equatable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(carbonModifiers)
    }
    
    public static func ==(lhs: KeyScheme, rhs: KeyScheme) -> Bool {
        return lhs.key == rhs.key &&
            lhs.carbonModifiers == rhs.carbonModifiers
    }
    
}

extension NSEvent.ModifierFlags {
    
    public var carbonValue: UInt32 {
        var flags: UInt32 = 0
        
        if contains(.command) {
            flags |= UInt32(cmdKey)
        }
        
        if contains(.option) {
            flags |= UInt32(optionKey)
        }
        
        if contains(.control) {
            flags |= UInt32(controlKey)
        }
        
        if contains(.shift) {
            flags |= UInt32(shiftKey)
        }
        
        return flags
    }
    
}
