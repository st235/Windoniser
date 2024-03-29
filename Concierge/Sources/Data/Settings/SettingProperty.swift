protocol SettingProperty {

    var type: SettingType { get }
    
    var value: Any? { get set }
    
    func isTrullyNew(value: Any?) -> Bool
    
}
