import Foundation

extension NSView {
    
    func asImage() -> NSImage {
        let viewSize = self.bounds.size
        let imageSize = NSMakeSize(viewSize.width, viewSize.height)
        
        guard let bitmap = bitmapImageRepForCachingDisplay(in: bounds) else {
            fatalError("Cannot initialize bitmap")
        }
        
        bitmap.size = imageSize
        
        cacheDisplay(in: bounds, to: bitmap)
        
        let image = NSImage(size: imageSize)
        image.addRepresentation(bitmap)
        
        return image
    }
    
}
