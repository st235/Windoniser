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
                
        navigationContainer.wantsLayer = true
        navigationContainer.layer?.backgroundColor = NSColor(named: .backgroundPrimary)?.cgColor
        
        push(controllerId: .settingsList)
    }
    
    @objc private func onBackClicked(_ sender: Any?) {
        if !navigationDelegate.pop() {
            (parent as? Navigatable)?.pop()
        }
    }
    
    func push(controllerId: ViewControllerFactory.ID, bundle: Any? = nil) {
        navigationDelegate.push(controllerId: controllerId, bundle: bundle)
    }
    
    func pop() -> Bool {
        return navigationDelegate.pop()
    }
        
}
