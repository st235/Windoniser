import Foundation

class NavigationDelegate: Navigatable {
    
    private weak var containerView: NSView!
    private weak var viewController: NSViewController!
    private let viewControllerFactory: ViewControllerFactory
    
    private var callStack: [NSViewController] = []
    
    init(containerView: NSView, viewController: NSViewController, viewControllerFactory: ViewControllerFactory) {
        self.containerView = containerView
        self.viewController = viewController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func push(controllerId: ViewControllerFactory.ID, bundle: Any? = nil) {
        if (!callStack.isEmpty) {
            let oldController = callStack.last
            oldController?.view.isHidden = true
        }
        
        let controller = viewControllerFactory.create(id: controllerId)
        
        (controller as? NavigatableViewController)?.bundle = bundle
        
        self.viewController.addChild(controller)
        controller.view.frame = self.containerView.bounds
        self.containerView.addSubview(controller.view)
        callStack.append(controller)
    }
    
    func stack() -> [NSViewController] {
        return callStack
    }
    
    func pop() -> Bool {
        let controller = callStack.removeLast()
    
        controller.removeFromParent()
        controller.view.removeFromSuperview()
        
        if (!callStack.isEmpty) {
            let newController = callStack.last
            newController?.view.isHidden = false
        }
        
        return !callStack.isEmpty
    }
    
}
