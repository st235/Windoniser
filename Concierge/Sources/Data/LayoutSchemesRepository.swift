import Foundation

class LayoutSchemesRepository {
    
    private static let keySelectedScheme = "key.selected_scheme"
    
    private static let schemes = [
        LayoutSchema(type: .fullscreen, areas: [.main], separators: []),
        LayoutSchema(type: .twoVertical, areas: [.left, .right], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1))]),
        LayoutSchema(type: .twoHoriontal, areas: [.top, .bottom], separators: [Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        LayoutSchema(type: .threeVertical, areas: [.verticalOneThird, .verticalTwoThird, .verticalThreeThird], separators: [Vector2(x: NSPoint(x: 1.0/3.0, y: 0), y: NSPoint(x: 1.0/3.0, y: 1)), Vector2(x: NSPoint(x: 2.0/3.0, y: 0), y: NSPoint(x: 2.0/3.0, y: 1))]),
        LayoutSchema(type: .quadro, areas: [.topLeft, .topRight, .bottomLeft, .bottomRight], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)), Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        LayoutSchema(type: .leftTrio, areas: [.left, .topRight, .bottomRight], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),Vector2(x: NSPoint(x: 0.5, y: 0.5), y: NSPoint(x: 1, y: 0.5))])
    ]
    
    private let userDefaults = UserDefaults.standard
    
    var defaultSchema: LayoutSchema {
        get {
            LayoutSchema(type: .fullscreen, areas: [.main], separators: [])
        }
    }
    
    var prefferedScheme: LayoutSchema {
        get {
            let rawSelectedValue: Int = userDefaults.integer(forKey: LayoutSchemesRepository.keySelectedScheme)
            guard let scheme: LayoutSchema = LayoutSchemesRepository.schemes.first(where: { $0.type.rawValue == rawSelectedValue }) else {
                fatalError()
            }
            
            return scheme
        }
        set {
            userDefaults.set(newValue.type.rawValue, forKey: LayoutSchemesRepository.keySelectedScheme)
        }
    }
    
    var defaultSchemes: [LayoutSchema] {
        get {
            return LayoutSchemesRepository.schemes
        }
    }
    
    func findSchema(byId rawId: Int) -> LayoutSchema {
        guard let schema = LayoutSchemesRepository.schemes.first(where: { $0.type.rawValue == rawId }) else {
            fatalError()
        }
        return schema
    }
    
}
