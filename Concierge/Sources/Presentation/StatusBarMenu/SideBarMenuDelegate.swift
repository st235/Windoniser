import Foundation

protocol SideBarMenuDelegate {
    
    func canHandle(sideBarEvent: SideBarEvent) -> Bool
    
    func attach()
    
}
