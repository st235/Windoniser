import Foundation

class HotKeysInteractor: LayoutSchemesInteractor.Delegate {
    
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    private let windowInteractor: WindowInteractor
    private let hotKeysController: HotKeyController
    
    private var hotKeys: [KeyScheme] = []
    
    init(layoutSchemesInteractor: LayoutSchemesInteractor,
         windowInteractor: WindowInteractor,
         hotKeysController: HotKeyController) {
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.windowInteractor = windowInteractor
        self.hotKeysController = hotKeysController
        
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
        let scheme = layoutSchemesInteractor.activeScheme
        
        for area in scheme.areas {
            let keyScheme = KeyScheme(key: area.activeKey, modifiers: area.modifiers)
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
    
}
