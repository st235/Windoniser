import Foundation

class LeftSideMenuDelegate: NSObject, SideBarMenuDelegate {
    
    private let popover = Popover(isAutoCancellable: true)
    private let statusBarMenuItem: NSStatusItem
    
    private let appearanceController: AppearanceController
    
    init(statusBarMenuItem: NSStatusItem, appearanceController: AppearanceController) {
        self.statusBarMenuItem = statusBarMenuItem
        self.appearanceController = appearanceController
        
        super.init()
        
        popover.appearance = NSAppearance(named: appearanceController.systemAppearance)!
        
        appearanceController.addObserver(observer: { _ in
            self.popover.appearance = NSAppearance(named: self.appearanceController.systemAppearance)!
        })
    }
    
    func canHandle(sideBarEvent: SideBarEvent) -> Bool {
        if case let SideBarEvent.mouse(event) = sideBarEvent {
            return event == .leftMouseUp
        }
        
        return false
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
        self.popover.contentViewController = LeftSideMenuViewController.create()
        self.popover.show(relativeTo: button)
      }
    }

    private func close(statusBarMenuItem: NSStatusItem) {
        self.popover.dismiss()
    }
    
}
