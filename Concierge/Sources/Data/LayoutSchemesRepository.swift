import Foundation

class LayoutSchemesRepository {
    
    private static let keySelectedScheme = "key.selected_scheme"
    
    private static let schemes = [
        // base is bottom-left corner
        
        // ubreakable
        LayoutSchema(type: .fullscreen, areas: [.main], separators: []),
        
        // default
        LayoutSchema(type: .twoVertical, areas: [.left, .right], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1))]),
        LayoutSchema(type: .twoHoriontal, areas: [.top, .bottom], separators: [Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        LayoutSchema(type: .threeVertical, areas: [.verticalOneThird, .verticalTwoThird, .verticalThreeThird], separators: [Vector2(x: NSPoint(x: 1.0/3.0, y: 0), y: NSPoint(x: 1.0/3.0, y: 1)), Vector2(x: NSPoint(x: 2.0/3.0, y: 0), y: NSPoint(x: 2.0/3.0, y: 1))]),
        LayoutSchema(type: .quadro, areas: [.topLeft, .topRight, .bottomLeft, .bottomRight], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)), Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        
        // custom
        LayoutSchema(type: 6, areas: [
            LayoutArea(titleKey: "left", activeKey: .one, rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
            LayoutArea(titleKey: "top_right", activeKey: .two, rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)),
            LayoutArea(titleKey: "bottom_right", activeKey: .three, rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
        ], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),Vector2(x: NSPoint(x: 0.5, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        
        LayoutSchema(type: 10, areas: [
            LayoutArea(titleKey: "top_left", activeKey: .one, rect: NSRect(x: 0, y: 0.5, width: 0.5, height: 0.5)),
            LayoutArea(titleKey: "bottom_left", activeKey: .two, rect: NSRect(x: 0, y: 0, width: 0.5, height: 0.5)),
            LayoutArea(titleKey: "right", activeKey: .three, rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
        ], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 0.5, y: 0.5))]),
        
        LayoutSchema(type: 11, areas: [
            LayoutArea(titleKey: "left", activeKey: .leftArrow, rect: NSRect(x: 0, y: 0, width: 0.33, height: 1.0)),
            LayoutArea(titleKey: "top", activeKey: .upArrow, rect: NSRect(x: 0.33, y: 0.5, width: 0.33, height: 0.5)),
            LayoutArea(titleKey: "bottom", activeKey: .downArrow, rect: NSRect(x: 0.33, y: 0, width: 0.33, height: 0.5)),
            LayoutArea(titleKey: "right", activeKey: .rightArrow, rect: NSRect(x: 0.66, y: 0, width: 0.34, height: 1))
        ], separators: [Vector2(x: NSPoint(x: 0.33, y: 0), y: NSPoint(x: 0.33, y: 1)), Vector2(x: NSPoint(x: 0.66, y: 0), y: NSPoint(x: 0.66, y: 1.0)), Vector2(x: NSPoint(x: 0.33, y: 0.5), y: NSPoint(x: 0.66, y: 0.5))])
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
            guard let scheme: LayoutSchema = LayoutSchemesRepository.schemes.first(where: { $0.type == rawSelectedValue }) else {
                fatalError()
            }
            
            return scheme
        }
        set {
            userDefaults.set(newValue.type, forKey: LayoutSchemesRepository.keySelectedScheme)
        }
    }
    
    var defaultSchemes: [LayoutSchema] {
        get {
            return LayoutSchemesRepository.schemes
        }
    }
    
    func findSchema(byId rawId: Int) -> LayoutSchema {
        guard let schema = LayoutSchemesRepository.schemes.first(where: { $0.type == rawId }) else {
            fatalError()
        }
        return schema
    }
    
}
