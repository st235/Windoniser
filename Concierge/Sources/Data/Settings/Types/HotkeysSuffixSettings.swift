import Foundation

class HotkeysSuffixSettings: SettingProperty {
    
    private static let userDefaultsTitle = "ud.param.hotkeys_settings"
    
    private let userDefaults: UserDefaults
    
    var type: SettingType = .hotkeysSuffix
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var value: Any? {
        get {
            let rawHotKeys = userDefaults.array(forKey: HotkeysSuffixSettings.userDefaultsTitle) as? [UInt32]
            return rawHotKeys?.map({ Key(carbonKeyCode: $0) }) ?? []
        }
        
        set {
            userDefaults.setValue((newValue as? [Key])?.map({ $0.carbonKeyCode }), forKey: HotkeysSuffixSettings.userDefaultsTitle)
        }
    }
    
    func isTrullyNew(value: Any?) -> Bool {
        return (self.value as? [Key]) != (value as? [Key])
    }
    
}
