import Foundation

class GridColorSetting: SettingProperty {
    
    private static let GRID_COLOR_KEY = "grid_color"
    
    var type: SettingType = .gridColor
    
    private let userDefault: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefault = userDefaults
    }
    
    var value: Any? {
        get {
            let id = userDefault.integer(forKey: GridColorSetting.GRID_COLOR_KEY)
            return GridTheme(rawValue: id) ?? GridTheme.followSystem
        }
        
        set {
            let gridColor = newValue as! GridTheme
            userDefault.setValue(gridColor.rawValue, forKey: GridColorSetting.GRID_COLOR_KEY)
        }
    }
    
    func isTrullyNew(value: Any?) -> Bool {
        return (self.value as! GridTheme) != (value as! GridTheme)
    }
    
}
