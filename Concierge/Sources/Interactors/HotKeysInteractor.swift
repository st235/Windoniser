import Foundation

class HotKeysInteractor {
    
    private let layoutSchemesRepository: LayoutSchemesRepository
    private let windowInteractor: WindowInteractor
    private let hotKeysController: HotKeyController
    
    private var hotKeys: [KeyScheme] = []
    
    init(layoutSchemesRepository: LayoutSchemesRepository,
         windowInteractor: WindowInteractor,
         hotKeysController: HotKeyController) {
        self.layoutSchemesRepository = layoutSchemesRepository
        self.windowInteractor = windowInteractor
        self.hotKeysController = hotKeysController
    }
    
    func register() {
        let scheme = layoutSchemesRepository.providePreferredScheme()
        
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
