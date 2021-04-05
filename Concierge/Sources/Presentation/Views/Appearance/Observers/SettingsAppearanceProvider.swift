import Foundation

class SettingsAppearanceProvider: AppearanceProvider {
    
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }
    
    func canHandle(mode: AppearanceMode) -> Bool {
        return mode == .forceDark || mode == .forceLight
    }
    
    func fetch() -> AppearanceType {
        switch settingsManager.get(type: .appearance) as AppearanceMode {
        case .forceDark:
            return .dark
        case .forceLight:
            return .light
        default:
            fatalError()
        }
    }
    
}
