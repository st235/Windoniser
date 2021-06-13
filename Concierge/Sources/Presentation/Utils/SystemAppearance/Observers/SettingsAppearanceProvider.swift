import Foundation

class SettingsAppearanceProvider: AppearanceProvider {
    
    private let appearanceInteractor: AppearanceInteractor
    
    init(appearanceInteractor: AppearanceInteractor) {
        self.appearanceInteractor = appearanceInteractor
    }
    
    func canHandle(mode: AppearanceMode) -> Bool {
        return mode == .forceDark || mode == .forceLight
    }
    
    func fetch() -> SystemSupportedAppearanceType {
        switch appearanceInteractor.activeAppearance {
        case .forceDark:
            return .dark
        case .forceLight:
            return .light
        default:
            fatalError()
        }
    }
    
}
