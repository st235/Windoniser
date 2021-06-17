import Foundation

class MainWindowController: LayoutSchemesInteractor.Delegate {
    
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let popover = Popover(isAutoCancellable: true)
    
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    private let accessibilityPermissionsManager: AccessibilityPermissionsManager
    private let viewControllerFactory: ViewControllerFactory
    private let appearanceController: SystemAppearanceController
    
    init(layoutSchemesInteractor: LayoutSchemesInteractor,
         accessibilityPermissionsManager: AccessibilityPermissionsManager,
         viewControllerFactory: ViewControllerFactory,
         appearanceController: SystemAppearanceController) {
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.accessibilityPermissionsManager = accessibilityPermissionsManager
        self.viewControllerFactory = viewControllerFactory
        self.appearanceController = appearanceController
        
        self.layoutSchemesInteractor.addDelegate(weak: self)
        
        popover.appearance = NSAppearance(named: appearanceController.systemAppearance)!
        
        appearanceController.addObserver(observer: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.popover.appearance = NSAppearance(named: appearanceController.systemAppearance)!
            if let button = self.statusBarItem.button {
                button.image = LayoutSchemaRenderer.render(layoutSchema: layoutSchemesInteractor.activeSchema, appearance: NSAppearance(named: appearanceController.systemAppearance)!)
            }
        })
    }
    
    func onActiveSchemeChanged(schemes: LayoutSchema) {
        if let button = statusBarItem.button {
            button.image = LayoutSchemaRenderer.render(layoutSchema: layoutSchemesInteractor.activeSchema, appearance: NSAppearance(named: appearanceController.systemAppearance)!)
        }
    }
    
    func onSelectedSchemasChanged() {
        // empty on purpose
    }
    
    func attach() {        
        if let button = statusBarItem.button {
            button.image = LayoutSchemaRenderer.render(layoutSchema: layoutSchemesInteractor.activeSchema, appearance: NSAppearance(named: appearanceController.systemAppearance)!)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
            button.action = #selector(onStatusBarItemClick(_:))
        }
    }
    
    @objc private func onStatusBarItemClick(_ sender: Any?) {
        toggle()
    }
    
    private func toggle() {
      if popover.isShown {
        close(statusBarMenuItem: statusBarItem)
      } else {
        show(statusBarMenuItem: statusBarItem)
      }
    }

    private func show(statusBarMenuItem: NSStatusItem) {
      if let button = statusBarMenuItem.button {
        self.popover.contentViewController = viewControllerFactory.create(id: .main)
        self.popover.show(relativeTo: button)
      }
    }

    private func close(statusBarMenuItem: NSStatusItem) {
        self.popover.dismiss()
    }
    
}
