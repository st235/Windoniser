import Foundation

class TouchBarInteractor {
    
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    var touchBarEnabled: Bool {
        get {
            return settingsRepository.get(type: .touchBar)
        }
        set {
            settingsRepository.set(type: .touchBar, value: newValue)
        }
    }
    
}
