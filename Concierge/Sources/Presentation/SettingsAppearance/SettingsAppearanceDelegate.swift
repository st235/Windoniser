import Foundation

final class SettingsAppearanceDelegate: SettingsDelegate {
    
    private lazy var apperanceList: [AppearanceMode] = {
        appearanceInteractor.availableAppearances()
    }()
    
    private let apperanceLocalizationKeys = [
        AppearanceMode.followSystem: "settings_appearance_theme_system",
        AppearanceMode.forceLight: "settings_appearance_theme_light",
        AppearanceMode.forceDark: "settings_appearance_theme_dark"
    ]
    
    private let header: NSTextField
    private let content: NSSegmentedControl
    
    private let appearanceInteractor: AppearanceInteractor
    
    init(header: NSTextField,
         content: NSSegmentedControl,
         appearanceInteractor: AppearanceInteractor) {
        self.header = header
        self.content = content
        self.appearanceInteractor = appearanceInteractor
    }
    
    func update() {
        updateHeader()
        updateContent()
    }
    
    private func updateHeader() {
        
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
        appearanceInteractor.activeAppearance = self.apperanceList[index]
    }
    
    private func currentAppearance() -> Int {
        let appearance: AppearanceMode = appearanceInteractor.activeAppearance
        return apperanceList.firstIndex(of: appearance)!
    }
    
    private func localizationForIndex(index: Int) -> String {
        let appearance = apperanceList[index]
        return apperanceLocalizationKeys[appearance]!.localized
    }
    
}
