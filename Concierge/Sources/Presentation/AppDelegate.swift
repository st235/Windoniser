import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusBarMenuController = StatusBarMenuController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarMenuController.attach()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // empty on purpose
    }

}

