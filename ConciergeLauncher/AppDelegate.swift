import Cocoa
import Foundation

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@main
class AppDelegate: NSObject {

    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let mainAppIdentifier = "st235.com.github.windoniser"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: mainAppIdentifier)

            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.removeLast() // removes Contents and exit to Application folder

            let newPath = NSString.path(withComponents: components)
            
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.promptsUserIfNeeded = true

            NSWorkspace.shared.openApplication(at: URL(fileURLWithPath: newPath), configuration: configuration, completionHandler: { [weak self] app, error in
                if error != nil {
                    print("Error happened: \(String(describing: error?.localizedDescription))")
                }
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.terminate()
                }
            })
        }
        else {
            self.terminate()
        }
    }
}
