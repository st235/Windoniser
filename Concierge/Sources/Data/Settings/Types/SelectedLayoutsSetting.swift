import Foundation

class SelectedLayoutsSetting: SettingProperty {
    
    private static let SELECTED_LAYOUTS_KEY = "selected_layouts"
    
    var type: SettingType = .selectedLayouts
    
    private let userDefault: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefault = userDefaults
    }
    
    var value: Any? {
        get {
            guard let rawValue = userDefault.array(forKey: SelectedLayoutsSetting.SELECTED_LAYOUTS_KEY) as? [Int] else {
                return []
            }
            return rawValue
        }
        
        set {
            let selectedLayouts = newValue as! [Int]
            userDefault.setValue(selectedLayouts, forKey: SelectedLayoutsSetting.SELECTED_LAYOUTS_KEY)
        }
    }
    
    func isTrullyNew(value: Any?) -> Bool {
        return Set(self.value as! [Int]) != Set(value as! [Int])
    }
    
}
