import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusBarMenuController: StatusBarMenuController = AppDependenciesResolver.shared.resolve(type: StatusBarMenuController.self)
    private let hotKeysManager: HotKeysInteractor = AppDependenciesResolver.shared.resolve(type: HotKeysInteractor.self)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarMenuController.attach()
        hotKeysManager.register()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        hotKeysManager.unregister()
    }

}

