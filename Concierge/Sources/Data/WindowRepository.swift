import AppKit

final class WindowRepository {
    
    public struct WindowInfo: Equatable, Hashable {
        let id: Int
        let pid: pid_t
        let title: String
        let owner: String?
        let icon: NSImage?
        
        init(id: Int, pid: pid_t, title: String, owner: String?, icon: NSImage?) {
            self.id = id
            self.pid = pid
            self.title = title
            self.owner = owner
            self.icon = icon
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(pid)
            hasher.combine(title)
            hasher.combine(owner)
            hasher.combine(icon)
        }
        
        public static func ==(lhs: WindowInfo, rhs: WindowInfo) -> Bool {
            return lhs.id == rhs.id && lhs.pid == rhs.pid && lhs.title == rhs.title && lhs.owner == rhs.owner && lhs.icon == rhs.icon
        }
    }
    
    private let windowController: WindowController
    
    init(windowController: WindowController) {
        self.windowController = windowController
    }
    
    public func findWindow(byPid pid: pid_t, andId id: Int) -> Window? {
        let windows = windowController.findAllAvailableWindows()
        let appsDict = queryRunningApps()
        
        for window in windows {
            guard let window = window as? Window,
                  let runningApp = appsDict[window.pid] else {
                continue
            }
            
            if shouldFilter(window: window, runningApp: runningApp) {
                continue
            }
            
            if window.pid != pid || window.number != id {
                continue
            }
        
            return window
        }
        
        return nil
    }
    
    public func focusedWindow() -> Window? {
        return windowController.active()
    }
    
    public func activeWindows() -> [WindowInfo] {
        let appsDict = queryRunningApps()
        
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
            
            windowInfos.insert(
                WindowInfo(id: window.number, pid: window.pid, title: window.title(), owner: runningApp.localizedName, icon: runningApp.icon)
            )
        }
        
        return Array(windowInfos)
    }
    
    private func shouldFilter(window: Window, runningApp: NSRunningApplication) -> Bool {
        let title = window.title()
        return title.isEmpty || runningApp.isHidden || runningApp.isTerminated || runningApp.activationPolicy != .regular
    }
    
    private func queryRunningApps() -> [pid_t:NSRunningApplication] {
        var appsDict = [pid_t:NSRunningApplication]()
        
        let runningApps = NSWorkspace.shared.runningApplications
        for runningApp in runningApps {
            appsDict[runningApp.processIdentifier] = runningApp
        }
        
        return appsDict
    }
    
}
