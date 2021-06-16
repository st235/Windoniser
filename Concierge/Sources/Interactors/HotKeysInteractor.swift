import Foundation

class HotKeysInteractor: LayoutSchemesInteractor.Delegate {
    
    private static let defaultKeyscheme: NSEvent.ModifierFlags = [.control, .shift]
    
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    private let windowInteractor: WindowInteractor
    private let hotKeysController: HotKeyController
    private let settingsRepository: SettingsRepository
    
    private var hotKeys: [KeyScheme] = []
    
    var keyModifiers: [Key] {
        get {
            let rawModifiers: [Key] = self.settingsRepository.get(type: .hotkeysSuffix)
            
            if !self.isValidKeyScheme(keys: rawModifiers) {
                return [.control, .shift]
            }
            
            return rawModifiers
        }
        set {
            if !self.isValidKeyScheme(keys: newValue) {
                return
            }
            
            unregister()
            settingsRepository.set(type: .hotkeysSuffix, value: newValue)
            register()
        }
    }
    
    private var rawModifiers: NSEvent.ModifierFlags {
        get {
            let rawValues: [Key] = self.settingsRepository.get(type: .hotkeysSuffix)
            
            if !self.isValidKeyScheme(keys: rawValues) {
                return HotKeysInteractor.defaultKeyscheme
            }
            
            var modifierFlag = NSEvent.ModifierFlags()
            
            for key in rawValues {
                modifierFlag.insert(key.modifierFlag!)
            }
            
            return modifierFlag
        }
    }
    
    init(layoutSchemesInteractor: LayoutSchemesInteractor,
         windowInteractor: WindowInteractor,
         hotKeysController: HotKeyController,
         settingsRepository: SettingsRepository) {
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.windowInteractor = windowInteractor
        self.hotKeysController = hotKeysController
        self.settingsRepository = settingsRepository
        
        self.layoutSchemesInteractor.addDelegate(weak: self)
    }
    
    func onActiveSchemeChanged(schemes: LayoutSchema) {
        unregister()
        register()
    }
    
    func onSelectedSchemasChanged() {
        // empty on purpose
    }
    
    func register() {
        let scheme = layoutSchemesInteractor.activeSchema
        
        for area in scheme.areas {
            let keyScheme = KeyScheme(key: area.activeKey, modifiers: rawModifiers)
            hotKeysController.register(keyScheme: keyScheme)
            
            keyScheme.onKeyDownListener = { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.windowInteractor.resizeFocusedWindow(intoRect: area.rect)
            }
            
            hotKeys.append(keyScheme)
        }
    }
    
    func unregister() {
        for hotKey in hotKeys {
            hotKeysController.unregister(keyScheme: hotKey)
        }
        
        hotKeys.removeAll()
    }
    
    private func isValidKeyScheme(keys: [Key]) -> Bool {
        if keys.isEmpty {
            return false
        }
        
        for key in keys {
            if key.modifierFlag == nil {
                return false
            }
        }
        
        return true
    }
    
}
