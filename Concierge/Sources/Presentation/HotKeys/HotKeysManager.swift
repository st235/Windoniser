import Foundation

class HotKeysManager {
    
    private let layoutSchemesRepository: LayoutSchemesRepository
    private let screenController: ScreensController
    private let windowRepository: WindowRepository
    private let hotKeysController: HotKeyController
    
    private var hotKeys: [KeyScheme] = []
    
    init(layoutSchemesRepository: LayoutSchemesRepository,
         windowRepository: WindowRepository,
         screenController: ScreensController,
         hotKeysController: HotKeyController) {
        self.layoutSchemesRepository = layoutSchemesRepository
        self.screenController = screenController
        self.windowRepository = windowRepository
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
                
                let reverse = NSRect(x: area.rect.minX, y: 1.0 - area.rect.height - area.rect.minY, width: area.rect.width, height: area.rect.height)
                let activeWindow = self.windowRepository.focusedWindow()
                self.screenController.resize(window: activeWindow, projection: reverse)
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
