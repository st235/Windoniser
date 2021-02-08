import Foundation

struct LayoutScheme {
    
    enum TypeId: Int {
        case fullscreen = 0
        case twoHoriontal = 1
        case twoVertical = 2
        case threeHorizontal = 3
        case threeVertical = 4
        case quadro = 5
        case leftTrio = 6
        case rightTrio = 7
        case custom = 8
    }
    
    let type: TypeId
    let areas: [LayoutArea]
    let separators: [Vector2]
    
    init(type: TypeId, areas: [LayoutArea], separators: [Vector2]) {
        self.type = type
        self.areas = areas
        self.separators = separators
    }
    
}
