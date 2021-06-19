import Foundation

struct LayoutSchema: Encodable, Decodable {
    
    typealias SchemaId = Int
    
    let id: SchemaId
    let isDefault: Bool
    let isUnselectable: Bool
    let areas: [LayoutArea]
    let separators: [Vector2]
}
