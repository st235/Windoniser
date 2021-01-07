import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBarMenuController: StatusBarMenuController = AppDependenciesResolver.shared.resolve(type: StatusBarMenuController.self)
        statusBarMenuController.attach()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // empty on purpose
    }

}

