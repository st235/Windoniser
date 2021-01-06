import Foundation

class WindowPidPasteboard: NSObject, Codable, NSPasteboardWriting, NSPasteboardReading {
    
    let pid: pid_t
    
    init(pid: pid_t) {
        self.pid = pid
    }
    
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        guard let data = propertyList as? Data,
              let obj = try? PropertyListDecoder().decode(WindowPidPasteboard.self, from: data) else {
            return nil
        }
        
        self.pid = obj.pid
    }
    
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.windowPid]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        switch type {
        case .windowPid:
            return try? PropertyListEncoder().encode(self)
        default:
            return nil
        }
    }
    
    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.windowPid]
    }
    
    static func readingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.ReadingOptions {
        return .asData
    }
    
}
