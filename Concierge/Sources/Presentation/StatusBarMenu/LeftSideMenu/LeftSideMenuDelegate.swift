import Foundation

class LeftSideMenuDelegate: NSObject, SideBarMenuDelegate {
    
    private let popover = NSPopover()
    private let eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
    private let statusBarMenuItem: NSStatusItem
    
    private let windowController: WindowController
    private let screenController: ScreensController
    private let windowRepository: WindowRepository
    
    init(statusBarMenuItem: NSStatusItem) {
        self.statusBarMenuItem = statusBarMenuItem
        
        self.windowController = WindowController()
        self.screenController = ScreensController(windowController: windowController)
        self.windowRepository = WindowRepository(windowController: windowController)
        
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
        self.popover.contentViewController = LeftSideMenuViewController.create(windowRepository: windowRepository, screenController: screenController)
        self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    private func close(statusBarMenuItem: NSStatusItem) {
        self.eventMonitor.stop()
        self.popover.performClose(statusBarMenuItem)
    }
    
}
