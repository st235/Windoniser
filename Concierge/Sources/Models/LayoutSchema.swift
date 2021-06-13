import Foundation

struct LayoutSchema {
    
    typealias TypeId = Int
    
    let type: Int
    let areas: [LayoutArea]
    let separators: [Vector2]
    
    init(type: TypeId, areas: [LayoutArea], separators: [Vector2]) {
        self.type = type
        self.areas = areas
        self.separators = separators
    }
    
}

extension LayoutSchema.TypeId {
    
    public static let fullscreen: Int = 0
    public static let twoHoriontal: Int = 1
    public static let twoVertical: Int = 2
    public static let threeHorizontal: Int = 3
    public static let threeVertical: Int = 4
    public static let quadro: Int = 5
    public static let leftTrio: Int = 6
    public static let rightTrio: Int = 7
    public static let custom: Int = 8
    
}
