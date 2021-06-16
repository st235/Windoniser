import Foundation

extension Key {
    
    var modifierFlag: NSEvent.ModifierFlags? {
        switch self {
        case .capsLock:
            return .capsLock
        case .shift:
            return .shift
        case .control:
            return .control
        case .option:
            return .option
        case .command:
            return .command
        case .function:
            return .function
        default:
            return nil
        }
    }
    
    static func extractKeys(flags: NSEvent.ModifierFlags) -> [Key] {
        var keys = [Key]()
        
        if flags.contains(.capsLock) {
            keys.append(.capsLock)
        }
        
        if flags.contains(.shift) {
            keys.append(.shift)
        }
        
        if flags.contains(.control) {
            keys.append(.control)
        }
        
        if flags.contains(.option) {
            keys.append(.option)
        }
        
        if flags.contains(.command) {
            keys.append(.command)
        }
        
        if flags.contains(.function) {
            keys.append(.function)
        }
        
        return keys
    }
    
}
