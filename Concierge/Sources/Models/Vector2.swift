import Foundation

struct Vector2: Encodable, Decodable {
    let start: Point
    let finish: Point
    
    var x: NSPoint {
        get {
            return NSPoint(x: CGFloat(start.x), y: CGFloat(start.y))
        }
    }
    
    var y: NSPoint {
        get {
            return NSPoint(x: CGFloat(finish.x), y: CGFloat(finish.y))
        }
    }
}
