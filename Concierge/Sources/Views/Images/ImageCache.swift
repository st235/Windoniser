import Foundation

class ImageCache {
    
    private let lock = NSLock()
    
    private var cache = [URL:NSImage]()
    
    func contains(url: URL) -> Bool {
        lock.lock()
        let contains = cache[url] != nil
        lock.unlock()
        return contains
    }
    
    @discardableResult func store(image: NSImage, forUrl url: URL) -> NSImage {
        lock.lock()
        cache[url] = image
        lock.unlock()
        return image
    }
    
    func get(url: URL) -> NSImage {
        lock.lock()
        let image = cache[url]
        guard image != nil else {
            fatalError("Image cannot be nil")
        }
        lock.unlock()
        return image!
    }
    
}
