import Foundation
import AppKit

class ScreensController {
    
    private let identityProjection = NSRect(x: 0, y: 0, width: 1, height: 1)
    
    private let windowController: WindowController
    
    init(windowController: WindowController) {
        self.windowController = windowController
    }
    
    // (0,0) is left top corner
    func resize(window: Window, projection: NSRect, andBringToFront: Bool = false) {
        guard let screen = self.findScreenFor(window: window) else {
            fatalError("Cannot find screen for window (position: \(window.position()), size: \(window.size())")
        }
        
        let realSize = project(identity: projection, on: screen)
        
        windowController.resize(window, position: realSize)
        
        if andBringToFront {
            windowController.bring(toFrontWindow: window)
        }
    }
    
    func findScreenFor(window: Window) -> NSScreen? {
        let windowRect = NSRect(origin: window.position(), size: window.size())
        
        var maxSquare = CGFloat(0.0)
        var maxScreen: NSScreen? = nil
        
        for screen in NSScreen.screens {
            let frame = invertAroundY(frame: screen.frame)
            
            var square = CGFloat(0.0)
            
            if frame.intersects(windowRect) {
                let intersction = frame.intersection(windowRect)
                square = intersction.width * intersction.height
            }
            
            if square > maxSquare {
                maxSquare = square
                maxScreen = screen
            }
        }
        
        return maxScreen
    }
    
    private func invertAroundY(frame: NSRect) -> NSRect {
        let newY =  NSMaxY(NSScreen.screens[0].frame) - NSMaxY(frame)
        return NSRect(x: frame.origin.x, y: newY, width: frame.width, height: frame.height)
    }
    
    private func project(identity: NSRect, on screen: NSScreen) -> NSRect {
        let frame = invertAroundY(frame: screen.visibleFrame)
        
        let projectedXScale = identity.width / identityProjection.width
        let projectedYScale = identity.height / identityProjection.height
        
        let projectedWidth = floor(projectedXScale * frame.width)
        let projectedHeight = floor(projectedYScale * frame.height)

        let projectedX = frame.minX + identity.minX * (frame.width / identityProjection.width)
        let projectedY = frame.minY + identity.minY * (frame.height / identityProjection.height)
        
        return NSRect(x: projectedX, y: projectedY, width: projectedWidth, height: projectedHeight)
    }
    
}
