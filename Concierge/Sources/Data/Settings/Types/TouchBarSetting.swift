import Foundation
import ServiceManagement

class TouchBarSetting: SettingProperty {
    
    private static let userDefaultsTitle = "ud.param.touch_bar"
    
    private let userDefaults: UserDefaults
    
    var type: SettingType = .touchBar
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var value: Any? {
        get {
            return userDefaults.bool(forKey: TouchBarSetting.userDefaultsTitle)
        }
        
        set {
            let isAutoLogin = (newValue as? Bool) == true ? true : false
            userDefaults.set(isAutoLogin, forKey: TouchBarSetting.userDefaultsTitle)
        }
    }
    
    func isTrullyNew(value: Any?) -> Bool {
        return (self.value as! Bool) != (value as! Bool)
    }
    
}
