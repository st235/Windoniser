import Foundation

protocol NavigationController {
    
    func push(controllerId: ViewControllerFactory.ID)
    
    func pop()
    
}
