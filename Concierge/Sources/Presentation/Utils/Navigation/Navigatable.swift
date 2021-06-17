import Foundation

protocol Navigatable {
    
    func push(controllerId: ViewControllerFactory.ID, bundle: Any?)
    
    func stack() -> [NSViewController]
    
    func pop() -> Bool
    
}
