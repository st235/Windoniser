import Foundation

class LayoutSchemesRepository {
    
    private static let keySelectedScheme = "key.selected_scheme"
    
    private static let schemes = [
        LayoutScheme(type: .fullscreen, areas: [.main], separators: []),
        LayoutScheme(type: .twoVertical, areas: [.left, .right], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1))]),
        LayoutScheme(type: .twoHoriontal, areas: [.top, .bottom], separators: [Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        LayoutScheme(type: .threeVertical, areas: [.verticalOneThird, .verticalTwoThird, .verticalThreeThird], separators: [Vector2(x: NSPoint(x: 1.0/3.0, y: 0), y: NSPoint(x: 1.0/3.0, y: 1)), Vector2(x: NSPoint(x: 2.0/3.0, y: 0), y: NSPoint(x: 2.0/3.0, y: 1))]),
        LayoutScheme(type: .quadro, areas: [.topLeft, .topRight, .bottomLeft, .bottomRight], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)), Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))]),
        LayoutScheme(type: .leftTrio, areas: [.left, .topRight, .bottomRight], separators: [Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),Vector2(x: NSPoint(x: 0.5, y: 0.5), y: NSPoint(x: 1, y: 0.5))])
    ]
    
    private let userDefaults = UserDefaults.standard
    
    var prefferedScheme: LayoutScheme {
        get {
            let rawSelectedValue: Int = userDefaults.integer(forKey: LayoutSchemesRepository.keySelectedScheme)
            guard let scheme: LayoutScheme = LayoutSchemesRepository.schemes.first(where: { $0.type.rawValue == rawSelectedValue }) else {
                fatalError()
            }
            
            return scheme
        }
        set {
            userDefaults.set(newValue.type.rawValue, forKey: LayoutSchemesRepository.keySelectedScheme)
        }
    }
    
    var defaultSchemes: [LayoutScheme] {
        get {
            return LayoutSchemesRepository.schemes
        }
    }
    
}
