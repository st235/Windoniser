import AppKit

class KeySchemeFactory {
    
    private let hotKeyController = HotKeyController()
    
    func create(key: Key, modifiers: NSEvent.ModifierFlags) -> KeyScheme {
        let keyScheme = KeyScheme(key: key, modifiers: modifiers)
        hotKeyController.register(keyScheme: keyScheme)
        return keyScheme
    }
    
}
