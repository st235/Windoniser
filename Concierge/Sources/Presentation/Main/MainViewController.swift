import Foundation

class MainViewController: NSViewController, NavigationController {
    
    @IBOutlet weak var containerView: NSView!
    
    private let viewControllerFactory: ViewControllerFactory = AppDependenciesResolver.shared.resolve(type: ViewControllerFactory.self)
    private let permissionsManager: AccessibilityPermissionsManager = AppDependenciesResolver.shared.resolve(type: AccessibilityPermissionsManager.self)
    
    private var callStack: [NSViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !permissionsManager.isPermissionGranted() {
            push(controllerId:  .permissions)
        } else {
            push(controllerId: .content)
        }
    }
    
    func push(controllerId: ViewControllerFactory.ID) {
        if (!callStack.isEmpty) {
            let oldController = callStack.last
            oldController?.view.isHidden = true
        }
        
        let controller = viewControllerFactory.create(id: controllerId)
        
        self.addChild(controller)
        controller.view.frame = self.containerView.bounds
        self.containerView.addSubview(controller.view)
        callStack.append(controller)
    }
    
    func pop() {
        let controller = callStack.removeLast()
    
        controller.removeFromParent()
        controller.view.removeFromSuperview()
        
        if (!callStack.isEmpty) {
            let newController = callStack.last
            newController?.view.isHidden = false
        }
    }
}
