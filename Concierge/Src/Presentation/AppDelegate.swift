import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusBarMenuController = StatusBarMenuController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusBarMenuController.attach()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

