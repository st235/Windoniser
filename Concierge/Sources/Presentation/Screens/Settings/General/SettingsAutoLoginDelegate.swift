import Foundation

final class SettingsAutoLoginDelegate: UiDelegate {
    
    private let header: NSTextField
    private let content: SwitcherItemView
    
    private let autoLoginInteractor: AutoLoginInteractor
    
    init(header: NSTextField,
         content: SwitcherItemView,
         autoLoginInteractor: AutoLoginInteractor) {
        self.header = header
        self.content = content
        self.autoLoginInteractor = autoLoginInteractor
    }
    
    func update() {
        updateHeader()
        updateContent()
    }
    
    private func updateHeader() {
        header.stringValue = "settings_general_auto_login_title".localized
    }
    
    private func updateContent() {
        content.title = "settings_general_auto_login_content".localized
        content.state = autoLoginInteractor.autoLoginEnabled
        
        content.clickHandler = { [weak self] enabled in
            guard let self = self else {
                return
            }
            
            self.autoLoginInteractor.autoLoginEnabled = enabled
        }
    }
    
}
