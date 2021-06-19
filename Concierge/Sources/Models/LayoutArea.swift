import Foundation

struct LayoutArea: Encodable, Decodable {
    
    let rawKey: String
    let origin: Origin
    let contentDescription: String
    
    var activeKey: Key {
        get {
            return Key(string: rawKey)!
        }
    }
    
    var rect: NSRect {
        get {
            NSRect(x: CGFloat(origin.x), y: CGFloat(origin.y), width: CGFloat(origin.width), height: CGFloat(origin.height))
        }
    }
    
}
