import Foundation

final class ImageLoader {
    
    private var requestsLock = NSLock()
    private var ongoingRequests = [UUID:URLSessionDataTask]()
    
    private let imageCache = ImageCache()
    
    func load(from url: URL, withCallback callback: @escaping (Result<NSImage, Error>) -> Void) -> UUID? {
        if imageCache.contains(url: url) {
            let image = imageCache.get(url: url)
            callback(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [imageCache] data, reponse, error in
            defer { self.unloadTask(id: uuid) }
                
            if let data = data, let image = NSImage(data: data) {
                imageCache.store(image: image, forUrl: url)
                DispatchQueue.main.async {
                    callback(.success(image))
                }
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
                return
            }
            
            // cancel
        }
        
        loadTask(id: uuid, task: task)
        task.resume()
        
        return uuid
    }
    
    func cancel(loadTaskWithId id: UUID) {
        let task = unloadTask(id: id)
        task?.cancel()
    }
    
    private func loadTask(id: UUID, task: URLSessionDataTask) {
        requestsLock.lock()
        ongoingRequests[id] = task
        requestsLock.unlock()
    }
    
    @discardableResult private func unloadTask(id: UUID) -> URLSessionDataTask? {
        requestsLock.lock()
        let task = ongoingRequests.removeValue(forKey: id)
        requestsLock.unlock()
        return task
    }
    
}
