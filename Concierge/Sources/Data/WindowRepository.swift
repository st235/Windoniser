import AppKit

final class WindowRepository {
    
    public struct WindowInfo: Equatable, Hashable {
        let pid: pid_t
        let title: String
        let owner: String?
        let icon: NSImage?
        
        init(pid: pid_t, title: String, owner: String?, icon: NSImage?) {
            self.pid = pid
            self.title = title
            self.owner = owner
            self.icon = icon
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(pid)
            hasher.combine(title)
            hasher.combine(owner)
            hasher.combine(icon)
        }
        
        public static func ==(lhs: WindowInfo, rhs: WindowInfo) -> Bool {
            return lhs.pid == rhs.pid && lhs.title == rhs.title && lhs.owner == rhs.owner && lhs.icon == rhs.icon
        }
    }
    
    private let windowController: WindowController
    
    init(windowController: WindowController) {
        self.windowController = windowController
    }
    
    public func findWindow(byPid pid: pid_t) -> Window? {
        return windowController.findWindow(byPid: pid)
    }
    
    public func focusedWindow() -> Window? {
        return windowController.active()
    }
    
    public func activeWindows() -> [WindowInfo] {
        var appsDict = [pid_t:NSRunningApplication]()
        
        let runningApps = NSWorkspace.shared.runningApplications
        for runningApp in runningApps {
            appsDict[runningApp.processIdentifier] = runningApp
        }
        
        let windows = windowController.findAllAvailableWindows()
        var windowInfos = Set<WindowInfo>()
        
        for window in windows {
            guard let window = window as? Window,
                  let runningApp = appsDict[window.pid] else {
                continue
            }
            
            if shouldFilter(window: window, runningApp: runningApp) {
                continue
            }
            
            windowInfos.insert(WindowInfo(pid: window.pid, title: window.title(), owner: runningApp.localizedName, icon: runningApp.icon))
        }
        
        return Array(windowInfos)
    }
    
    private func shouldFilter(window: Window, runningApp: NSRunningApplication) -> Bool {
        let title = window.title()
        return title.isEmpty || runningApp.isHidden || runningApp.isTerminated || runningApp.activationPolicy != .regular
    }
    
}
