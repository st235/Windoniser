import Foundation

class AutoLoginInteractor {
    
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    var autoLoginEnabled: Bool {
        get {
            return settingsRepository.get(type: .autoLogin)
        }
        set {
            settingsRepository.set(type: .autoLogin, value: newValue)
        }
    }
    
}
