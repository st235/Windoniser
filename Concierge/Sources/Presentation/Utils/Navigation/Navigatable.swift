import Foundation

protocol Navigatable {
    
    func push(controllerId: ViewControllerFactory.ID, bundle: Any?)
    
    func pop() -> Bool
    
}
