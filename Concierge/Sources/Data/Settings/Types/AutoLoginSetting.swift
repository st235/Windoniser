import Foundation
import ServiceManagement

class AutoLoginSetting: SettingProperty {
    
    private static let launcherBundleIdentifier = "st235.com.github.ConciergeLauncher"
    private static let userDefaultsTitle = "ud.param.auto_login"
    
    private let userDefaults: UserDefaults
    
    var type: SettingType = .autoLogin
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var value: Any? {
        get {
            return userDefaults.bool(forKey: AutoLoginSetting.userDefaultsTitle)
        }
        
        set {
            let isAutoLogin = (newValue as? Bool) == true ? true : false
            userDefaults.set(isAutoLogin, forKey: AutoLoginSetting.userDefaultsTitle)
            SMLoginItemSetEnabled(AutoLoginSetting.launcherBundleIdentifier as CFString, isAutoLogin)
        }
    }
    
    func isTrullyNew(value: Any?) -> Bool {
        return (self.value as! Bool) != (value as! Bool)
    }
    
}
