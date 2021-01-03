import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let menu = NSMenu()
    let popover = NSPopover()
    let windowController = WindowController()
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusBarItem.button {
            button.title = "Hello world"
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.action = #selector(onStatusBarClick(_:))
            
            menu.addItem(NSMenuItem(title: "Debug", action: #selector(debugActiveWindow(_:)), keyEquivalent: "d"))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "To left", action: #selector(onLeft(_:)), keyEquivalent: "l"))
            menu.addItem(NSMenuItem(title: "To right", action: #selector(onRight(_:)), keyEquivalent: "r"))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "1/3", action: #selector(firstThird(_:)), keyEquivalent: "1"))
            menu.addItem(NSMenuItem(title: "2/3", action: #selector(secondThird(_:)), keyEquivalent: "2"))
            menu.addItem(NSMenuItem(title: "3/3", action: #selector(lastThird(_:)), keyEquivalent: "3"))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Top-left", action: #selector(topLeft(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Bottom-left", action: #selector(bottomLeft(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Top-right", action: #selector(topRight(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Bottom-right", action: #selector(bottomRight(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
//            statusBarItem.menu = menu
            
//            statusBarItem.menu = menu
        }
        
        popover.contentViewController = MainViewController.newController()
    }
    
    @objc func debugActiveWindow(_ sender: Any?) {
        let activeWindow = windowController.active()
        
        print("title: \(activeWindow.title()) position: \(activeWindow.position()) size: \(activeWindow.size())")
    }
    
    @objc func onLeft(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0, y: 0, width: 0.5, height: 1))
    }
    
    @objc func onRight(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
    }
    
    @objc func firstThird(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0, y: 0, width: 0.33, height: 1))
    }
    
    @objc func secondThird(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0.33, y: 0, width: 0.33, height: 1))
    }
    
    @objc func lastThird(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0.66, y: 0, width: 0.34, height: 1))
    }
    
    @objc func topLeft(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0, y: 0, width: 0.5, height: 0.5))
    }
    
    @objc func bottomLeft(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0, y: 0.5, width: 0.5, height: 0.5))
    }
    
    @objc func topRight(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
    }
    
    @objc func bottomRight(_ sender: Any?) {
        let screenController = ScreensController(windowController: windowController)
        let activeWindow = windowController.active()
        screenController.resize(window: activeWindow, projection: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc private func onStatusBarClick(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            
        } else {
            togglePopover(sender)
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusBarItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
    }
}

