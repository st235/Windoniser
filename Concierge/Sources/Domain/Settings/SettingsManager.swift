import Foundation

class SettingsManager {
    
    private var userDefaults = UserDefaults.standard
    
    private let settings: [SettingProperty]
    
    init() {
        settings = [
            AutoLoginSetting(userDefaults: self.userDefaults)
        ]
    }
    
    func set(type: SettingType, value: Any?) {
        guard var settingProperty = settings.first(where: { $0.type == type }) else {
            fatalError("Cannot find requested settings property \(type)")
        }
        
        settingProperty.value = value
    }
    
    func get<T>(type: SettingType) -> T {
        guard let settingProperty = settings.first(where: { $0.type == type }) else {
            fatalError("Cannot find requested settings property \(type)")
        }
        
        guard let value = settingProperty.value as? T else {
            fatalError("Cannot cast value to \(T.self)")
        }
        
        return value
    }
    
}
