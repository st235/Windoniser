import Foundation

class SettingsKeySchemeUiDelegate: UiDelegate {
    
    private let header: NSTextField
    private let content: KeySchemeView
    
    private let hotKeysInteractor: HotKeysInteractor
    private let modifiersController: InAppModifiersController
    
    init(header: NSTextField,
         content: KeySchemeView,
         hotKeysInteractor: HotKeysInteractor) {
        self.header = header
        self.content = content
        self.hotKeysInteractor = hotKeysInteractor
        self.modifiersController = InAppModifiersController()
    }
    
    func update() {
        updateHeader()
        updateContent()
        
        modifiersController.onModifiersChangeListener = { [weak self] keys in
            guard let self = self else {
                return
            }
            
            print(keys)
            
            self.hotKeysInteractor.keyModifiers = keys
            self.updateContent()
        }
    }
    
    private func updateHeader() {
    }
    
    private func updateContent() {
        content.text = "settings_general_active_schema".localized
        content.rightButtonText = "settings_gemeral_change_active_schema".localized
        content.hotkeyBackgroundColor = NSColor.from(name: .backgroundPrimary)
        content.hotkeyTextColor = NSColor.from(name: .textPrimary)
        
        print(hotKeysInteractor.keyModifiers)
        content.setKeys(keys: hotKeysInteractor.keyModifiers)
        
        content.clickHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.modifiersController.listenUntilNewModifiersAppear(expectedCombination: 2)
        }
    }
    
    deinit {
        modifiersController.cancel()
    }
    
}
