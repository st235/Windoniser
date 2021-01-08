import Foundation

class WindowInteractor {
    
    private let windowRepository: WindowRepository
    private let screenController: ScreensController
    
    init(windowRepository: WindowRepository,
         screenController: ScreensController) {
        self.windowRepository = windowRepository
        self.screenController = screenController
    }
    
    func activeWindows() -> [WindowRepository.WindowInfo] {
        return windowRepository.activeWindows()
    }
    
    func resizeFocusedWindow(intoRect rect: NSRect) {
        let focusedWindow = windowRepository.focusedWindow()
        resizeWindow(window: focusedWindow, into: rect)
    }
    
    func resizeWindow(withPid pid: pid_t, into projection: NSRect) {
        let windowForPid = windowRepository.findWindow(byPid: pid)
        resizeWindow(window: windowForPid, into: projection)
    }
    
    private func resizeWindow(window: Window?, into projection: NSRect) {
        assert(window != nil, "Focused window is null. How come?")
        
        if let window = window {
            let reversedProjection = reverseRectToScreenCoordinates(rect: projection)
            screenController.resize(window: window, projection: reversedProjection)
        }
    }
    
    private func reverseRectToScreenCoordinates(rect: NSRect) -> NSRect {
        return NSRect(x: rect.minX, y: 1.0 - rect.height - rect.minY, width: rect.width, height: rect.height)
    }
    
}
