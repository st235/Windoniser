import Foundation

final class SettingsTouchBarDelegate: UiDelegate {
    
    private let header: NSTextField
    private let headerTooltip: NSView
    private let content: SwitcherItemView
    
    private let touchBarInteractor: TouchBarInteractor
    
    init(header: NSTextField,
         headerTooltip: NSView,
         content: SwitcherItemView,
         touchBarInteractor: TouchBarInteractor) {
        self.header = header
        self.headerTooltip = headerTooltip
        self.content = content
        self.touchBarInteractor = touchBarInteractor
    }
    
    func update() {
        updateHeader()
        updateContent()
    }
    
    private func updateHeader() {
        header.stringValue = "settings_general_touch_bar_header".localized
        headerTooltip.toolTip = "settings_general_touch_bar_header_tooltip".localized
    }
    
    private func updateContent() {
        content.title = "settings_general_touch_bar_content".localized
        content.state = touchBarInteractor.touchBarEnabled
        
        content.clickHandler = { [weak self] enabled in
            guard let self = self else {
                return
            }
            
            self.touchBarInteractor.touchBarEnabled = enabled
        }
    }
    
}
