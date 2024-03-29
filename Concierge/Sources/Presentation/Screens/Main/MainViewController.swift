import Foundation

class MainViewController: NSViewController, Navigatable {
    
    @IBOutlet weak var containerView: NSView!
    
    private let viewControllerFactory: ViewControllerFactory = AppDependenciesResolver.shared.resolve(type: ViewControllerFactory.self)
    private let permissionsManager: AccessibilityPermissionsManager = AppDependenciesResolver.shared.resolve(type: AccessibilityPermissionsManager.self)

    private var navigationDelegate: NavigationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationDelegate = NavigationDelegate(containerView: containerView, viewController: self, viewControllerFactory: viewControllerFactory)
        
        if !permissionsManager.isPermissionGranted() {
            push(controllerId:  .permissions)
        } else {
            push(controllerId: .content)
        }
    }
    
    func push(controllerId: ViewControllerFactory.ID, bundle: Any? = nil) {
        navigationDelegate.push(controllerId: controllerId, bundle: bundle)
    }
    
    func stack() -> [NSViewController] {
        return navigationDelegate.stack()
    }
    
    func pop() -> Bool {
        return navigationDelegate.pop()
    }
}
