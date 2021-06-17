import Foundation


class SettingsMainViewController: NSViewController, Navigatable {
    
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var navigationContainer: NSStackView!
    
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var headerLabel: NSTextField!
    
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
        if !self.pop() {
            (parent as? Navigatable)?.pop()
        }
    }
    
    func push(controllerId: ViewControllerFactory.ID, bundle: Any? = nil) {
        navigationDelegate.push(controllerId: controllerId, bundle: bundle)
        updateHeader()
    }
    
    func stack() -> [NSViewController] {
        return navigationDelegate.stack()
    }
    
    func pop() -> Bool {
        let result = navigationDelegate.pop()
        updateHeader()
        return result
    }
    
    private func updateHeader() {
        let callStack = navigationDelegate.stack()
        
        var backButtonText = "settings_general_back_title".localized
        
        if callStack.count > 1 {
            backButtonText = extractTitle(viewController: callStack[callStack.count - 2])
        }
        
        var headerTitle = "settings_general_header_title".localized
        
        if !callStack.isEmpty {
            headerTitle = extractTitle(viewController: callStack.last!)
        }
        
        backButton.title = backButtonText
        headerLabel.stringValue = headerTitle
    }
    
    private func extractTitle(viewController: NSViewController) -> String {
        return (viewController as? NavigatableViewController)?.navigationTitle ?? viewController.className
    }
        
}
