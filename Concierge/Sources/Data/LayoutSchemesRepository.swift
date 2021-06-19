import Foundation

class LayoutSchemesRepository {
    
    private static let keySelectedScheme = "key.selected_scheme"
    
    private let schemas: [LayoutSchema]
    
    private let userDefaults = UserDefaults.standard
    
    private let jsonDecoder = JSONDecoder()
    
    init() {
        let filePath = Bundle.main.path(forResource: "Schemas", ofType: "json")!
        let rawJson = try! String(contentsOfFile: filePath)
        self.schemas = try! jsonDecoder.decode([LayoutSchema].self, from: rawJson.data(using: .utf8)!)
    }
    
    var defaultSchema: LayoutSchema {
        get {
            return self.schemas.first(where: { $0.isDefault })!
        }
    }
    
    var prefferedScheme: LayoutSchema {
        get {
            let rawSelectedValue: Int = userDefaults.integer(forKey: LayoutSchemesRepository.keySelectedScheme)
            guard let scheme: LayoutSchema = schemas.first(where: { $0.id == rawSelectedValue }) else {
                return defaultSchema
            }
            
            return scheme
        }
        set {
            userDefaults.set(newValue.id, forKey: LayoutSchemesRepository.keySelectedScheme)
        }
    }
    
    var defaultSchemes: [LayoutSchema] {
        get {
            return schemas
        }
    }
    
    func findSchema(byId rawId: Int) -> LayoutSchema? {
        guard let schema = schemas.first(where: { $0.id == rawId }) else {
            return nil
        }
        return schema
    }
    
}
