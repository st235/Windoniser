import Foundation

class LeftSideMenuDelegate: NSObject, SideBarMenuDelegate {
    
    private let popover = NSPopover()
    private let statusBarMenuItem: NSStatusItem
    
    init(statusBarMenuItem: NSStatusItem) {        
        self.statusBarMenuItem = statusBarMenuItem
        self.popover.contentViewController = LeftSideMenuViewController.create()
    }
    
    func canHandle(event: NSEvent.EventType) -> Bool {
        return event == .leftMouseUp
    }
        
    func attach() {
        togglePopover(statusBarMenuItem: statusBarMenuItem)
    }
    
    @objc func togglePopover(statusBarMenuItem: NSStatusItem) {
      if popover.isShown {
        closePopover(statusBarMenuItem: statusBarMenuItem)
      } else {
        showPopover(statusBarMenuItem: statusBarMenuItem)
      }
    }

    func showPopover(statusBarMenuItem: NSStatusItem) {
      if let button = statusBarMenuItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(statusBarMenuItem: NSStatusItem) {
      popover.performClose(statusBarMenuItem)
    }
    
}
