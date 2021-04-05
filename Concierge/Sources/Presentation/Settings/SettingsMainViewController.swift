import Foundation


class SettingsMainViewController: NSViewController, Navigatable {
    
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var navigationContainer: NSStackView!
    @IBOutlet weak var backButton: NSButton!
    
    private let viewControllerFactory: ViewControllerFactory = AppDependenciesResolver.shared.resolve(type: ViewControllerFactory.self)
    private let permissionsManager: AccessibilityPermissionsManager = AppDependenciesResolver.shared.resolve(type: AccessibilityPermissionsManager.self)

    private var navigationDelegate: NavigationDelegate!
    
    override func viewDidLoad() {
        navigationDelegate = NavigationDelegate(containerView: containerView, viewController: self, viewControllerFactory: viewControllerFactory)
        
        backButton.target = self
        backButton.action = #selector(onBackClicked(_:))
                
        push(controllerId: .settingsList)
    }
    
    @objc private func onBackClicked(_ sender: Any?) {
        (parent as? Navigatable)?.pop()
    }
    
    func push(controllerId: ViewControllerFactory.ID) {
        navigationDelegate.push(controllerId: controllerId)
    }
    
    func pop() {
        navigationDelegate.pop()
    }
        
}
