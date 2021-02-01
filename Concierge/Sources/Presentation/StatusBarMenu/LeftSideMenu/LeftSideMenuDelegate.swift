import Foundation

class LeftSideMenuDelegate: NSObject, SideBarMenuDelegate {
    
    private let popover = Popover()
    private let eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
    private let statusBarMenuItem: NSStatusItem
    
    init(statusBarMenuItem: NSStatusItem) {
        self.statusBarMenuItem = statusBarMenuItem
        
        super.init()
        
        self.eventMonitor.handler = { [weak self] in
            guard let statusBarItem = self?.statusBarMenuItem else {
                return
            }
            
            if self?.popover.isShown != false {
                self?.close(statusBarMenuItem: statusBarItem)
            }
        }
    }
    
    func canHandle(event: NSEvent.EventType) -> Bool {
        return event == .leftMouseUp
    }
        
    func attach() {
        toggle(statusBarMenuItem: statusBarMenuItem)
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
        self.popover.contentViewController = LeftSideMenuViewController.create()
        self.popover.show(relativeTo: button)
      }
    }

    private func close(statusBarMenuItem: NSStatusItem) {
        self.eventMonitor.stop()
        self.popover.dismiss()
    }
    
}
