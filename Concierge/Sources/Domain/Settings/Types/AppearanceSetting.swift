import Foundation

class AppearanceSetting: SettingProperty {
    
    private static let APPEARANCE_KEY = "appearance_key"
    
    var type: SettingType = .appearance
    
    private let userDefault: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefault = userDefaults
    }
    
    var value: Any? {
        get {
            let rawValue = userDefault.integer(forKey: AppearanceSetting.APPEARANCE_KEY)
            return AppearanceMode(rawValue: rawValue) ?? AppearanceMode.followSystem
        }
        
        set {
            let type = newValue as! AppearanceMode
            userDefault.setValue(type.rawValue, forKey: AppearanceSetting.APPEARANCE_KEY)
        }
    }
    
    func isTrullyNew(value: Any?) -> Bool {
        return (self.value as! AppearanceMode) != (value as! AppearanceMode)
    }
    
}
