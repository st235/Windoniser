import Foundation

protocol Navigatable {
    
    func push(controllerId: ViewControllerFactory.ID)
    
    func pop() -> Bool
    
}
