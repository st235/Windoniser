import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusBarMenuController: MainWindowController = AppDependenciesResolver.shared.resolve(type: MainWindowController.self)
    private let hotKeysManager: HotKeysInteractor = AppDependenciesResolver.shared.resolve(type: HotKeysInteractor.self)
    private let touchBarBuilder: TouchBarBuilder = AppDependenciesResolver.shared.resolve(type: TouchBarBuilder.self)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarMenuController.attach()
        hotKeysManager.register()
        touchBarBuilder.attach()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        hotKeysManager.unregister()
    }

}

