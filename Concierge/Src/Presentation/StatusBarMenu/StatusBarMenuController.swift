import Foundation

class StatusBarMenuController {
    
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let delegates: [SideBarMenuDelegate]
    
    init() {
        self.delegates = [
            LeftSideMenuDelegate(statusBarMenuItem: self.statusBarItem),
            RightSideMenuDelegate(statusBarMenuItem: self.statusBarItem)
        ]
    }
    
    func attach() {        
        if let button = statusBarItem.button {
            button.title = "Windows"
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
            button.action = #selector(onStatusBarItemClick(_:))
        }
    }
    
    @objc private func onStatusBarItemClick(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        attachActiveDelegates(event: event.type)
    }
    
    private func attachActiveDelegates(event: NSEvent.EventType) {
        for delegate in delegates {
            if delegate.canHandle(event: event) {
                delegate.attach()
            }
        }
    }
    
}
