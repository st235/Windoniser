import AppKit

final class WindowRepository {
    
    public struct WindowInfo: Equatable, Hashable {
        let title: String
        let owner: String?
        let icon: NSImage?
        
        init(title: String, owner: String?, icon: NSImage?) {
            self.title = title
            self.owner = owner
            self.icon = icon
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
            hasher.combine(owner)
            hasher.combine(icon)
        }
        
        public static func ==(lhs: WindowInfo, rhs: WindowInfo) -> Bool {
            return lhs.title == rhs.title && lhs.owner == rhs.owner && lhs.icon == rhs.icon
        }
    }
    
    private let windowController: WindowController
    
    init(windowController: WindowController) {
        self.windowController = windowController
    }
    
    public func allWindows() -> Set<WindowInfo> {
        var appsDict = [pid_t:NSRunningApplication]()
        
        let runningApps = NSWorkspace.shared.runningApplications
        for runningApp in runningApps {
            appsDict[runningApp.processIdentifier] = runningApp
        }
        
        let windows = windowController.requestAllWindows()
        var windowInfos = Set<WindowInfo>()
        
        for window in windows {
            guard let window = window as? Window else {
                continue
            }
            
            guard let runningApp = appsDict[window.pid] else {
                continue
            }
            
            if shouldFilter(window: window, runningApp: runningApp) {
                continue
            }
            
            windowInfos.insert(WindowInfo(title: window.title(), owner: runningApp.localizedName, icon: runningApp.icon))
        }
        
        return windowInfos
    }
    
    private func shouldFilter(window: Window, runningApp: NSRunningApplication) -> Bool {
        let title = window.title()
        return title.isEmpty || runningApp.isHidden || runningApp.isTerminated
    }
    
}
