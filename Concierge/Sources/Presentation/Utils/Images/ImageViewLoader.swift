import Foundation

// not thread safe, call only from main thread
class ImageViewLoader {
    
    static let shared = ImageViewLoader()
    
    private let imageLoader = ImageLoader()
    private var imageViewIds = [NSImageView:UUID]()
    
    func load(url: URL, into view: NSImageView) {
        cancel(forView: view)
        
        let newId = imageLoader.load(from: url, withCallback: { result in
            defer { self.unloadId(fromView: view) }
            
            do {
                let image = try result.get()
                view.image = image
            } catch {
                print(error)
            }
        })
        
        imageViewIds[view] = newId
    }
    
    func cancel(forView view: NSImageView) {
        if let oldId = unloadId(fromView: view) {
            imageLoader.cancel(loadTaskWithId: oldId)
        }
    }
    
    @discardableResult private func unloadId(fromView view: NSImageView) -> UUID? {
        let id = imageViewIds[view]
        imageViewIds.removeValue(forKey: view)
        return id
    }
    
}
