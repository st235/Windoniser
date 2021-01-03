import Foundation

protocol SideBarMenuDelegate {
    
    func canHandle(event: NSEvent.EventType) -> Bool
    
    func attach()
    
}
