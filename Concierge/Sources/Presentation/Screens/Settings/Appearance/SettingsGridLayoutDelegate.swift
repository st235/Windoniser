import Foundation

final class SettingsGridLayoutDelegate: UiDelegate {
    
    private lazy var apperanceList: [GridTheme] = {
        gridLayoutInteractor.availableGridThemes()
    }()
    
    private let apperanceLocalizationKeys = [
        GridTheme.followSystem: "settings_appearance_theme_system",
        GridTheme.light: "settings_appearance_theme_light",
        GridTheme.dark: "settings_appearance_theme_dark"
    ]
    
    private let header: NSTextField
    private let content: NSSegmentedControl
    
    private let gridLayoutInteractor: GridLayoutInteractor
    
    init(header: NSTextField,
         content: NSSegmentedControl,
         gridLayoutInteractor: GridLayoutInteractor) {
        self.header = header
        self.content = content
        self.gridLayoutInteractor = gridLayoutInteractor
    }
    
    func update() {
        updateHeader()
        updateContent()
    }
    
    private func updateHeader() {
        header.stringValue = "settings_appearance_grid_layout_title".localized
    }
    
    private func updateContent() {
        for i in 0..<self.apperanceList.count {
            content.setLabel(localizationForIndex(index: i), forSegment: i)
        }
        
        content.setSelected(true, forSegment: currentAppearance())
        content.target = self
        content.action = #selector(onAppearanceValueChanged)
    }
    
    @objc private func onAppearanceValueChanged() {
        let index = content.indexOfSelectedItem
        gridLayoutInteractor.activeColor = self.apperanceList[index]
    }
    
    private func currentAppearance() -> Int {
        let gridTheme: GridTheme = gridLayoutInteractor.activeColor
        return apperanceList.firstIndex(of: gridTheme)!
    }
    
    private func localizationForIndex(index: Int) -> String {
        let gridTheme = apperanceList[index]
        return apperanceLocalizationKeys[gridTheme]!.localized
    }
    
}
