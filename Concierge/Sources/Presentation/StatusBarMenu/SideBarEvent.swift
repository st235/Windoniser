import Foundation

enum SideBarEvent {
    case mouse(event: NSEvent.EventType)
    case permissionError
    case error
}
