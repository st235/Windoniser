import Foundation

class PermissionsSideMenuDelegate {
    
    private let popover = Popover()
    private let eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
    private let statusBarMenuItem: NSStatusItem
    private let viewControllerFactory: ViewControllerFactory
    
    init(statusBarMenuItem: NSStatusItem,
         viewControllerFactory: ViewControllerFactory) {
        self.statusBarMenuItem = statusBarMenuItem
        self.viewControllerFactory = viewControllerFactory
        
        self.eventMonitor.handler = { [weak self] in
            guard let statusBarItem = self?.statusBarMenuItem else {
                return
            }
            
            if self?.popover.isShown != false {
                self?.close(statusBarMenuItem: statusBarItem)
            }
        }
    }
    
    private func toggle(statusBarMenuItem: NSStatusItem) {
      if popover.isShown {
        close(statusBarMenuItem: statusBarMenuItem)
      } else {
        show(statusBarMenuItem: statusBarMenuItem)
      }
    }

    private func show(statusBarMenuItem: NSStatusItem) {
      if let button = statusBarMenuItem.button {
        self.eventMonitor.start()
        self.popover.contentViewController = viewControllerFactory.create(id: .permissions)
        self.popover.show(relativeTo: button)
      }
    }

    private func close(statusBarMenuItem: NSStatusItem) {
        self.eventMonitor.stop()
        self.popover.dismiss()
    }
    
    
}
