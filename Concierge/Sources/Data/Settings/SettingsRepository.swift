import Foundation

typealias SettingsObserver = (Any?) -> Void

class SettingsRepository {
    
    private var userDefaults = UserDefaults.standard
    
    private let settings: [SettingProperty]
    
    private var observers = [SettingType:[SettingsObserver]]()
    
    init() {
        settings = [
            AutoLoginSetting(userDefaults: self.userDefaults),
            AppearanceSetting(userDefaults: self.userDefaults),
            GridColorSetting(userDefaults: self.userDefaults),
            SelectedLayoutsSetting(userDefaults: self.userDefaults),
            HotkeysSuffixSettings(userDefaults: self.userDefaults)
        ]
    }
    
    func set(type: SettingType, value: Any?) {
        guard var settingProperty = settings.first(where: { $0.type == type }) else {
            fatalError("Cannot find requested settings property \(type)")
        }
                
        if settingProperty.isTrullyNew(value: value) {
            settingProperty.value = value
            notify(withValue: value, andType: type)
        }
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
    
    func addObserver(type: SettingType, observer: @escaping SettingsObserver) {
        if observers[type] == nil {
            observers[type] = [SettingsObserver]()
        }
        
        observers[type]?.append(observer)
    }
    
    private func notify(withValue value: Any?, andType type: SettingType) {
        if let observers = observers[type] {
            for observer in observers {
                observer(value)
            }
        }
    }
    
}
