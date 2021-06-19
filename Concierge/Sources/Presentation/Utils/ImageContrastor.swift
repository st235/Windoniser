import Foundation

class ImageConstarstor {
    
    private let imageLoader: ImageLoader = ImageLoader()
    private var executingTasks = [URL:UUID]()
    
    func findFarestColor(forColors colors: [NSColor], forURL url: URL, _ completion: @escaping (NSColor?) -> Void) {
        if executingTasks[url] != nil {
            return
        }
        
        let uuid = imageLoader.load(from: url, withCallback: { [weak self] result in
            do {
                let image = try result.get()
                image.getColors(quality: .low) { [weak self] colorSchema in
                    let background = colorSchema?.background
                    self?.clear(url: url)
                    
                    completion(self?.farestAmong(palette: colors, forTarget: background))
                }
                
            } catch {
                print(error)
            }
        })
        
        executingTasks[url] = uuid
    }
    
    private func farestAmong(palette colors: [NSColor], forTarget target: NSColor?) -> NSColor? {
        guard let target = target?.usingColorSpace(.sRGB) else {
            return nil
        }
        
        var maxDistance: CGFloat = 0
        var closestColor: NSColor? = nil
        
        for color in colors {
            guard let color = color.usingColorSpace(.sRGB) else {
                continue
            }
            
            let distance = sqrt(
                pow(color.redComponent - target.redComponent, 2) +
                pow(color.blueComponent - target.blueComponent, 2) +
                pow(color.greenComponent - target.greenComponent, 2) +
                pow(color.alphaComponent - target.alphaComponent, 2)
            )
            
            if distance > maxDistance {
                maxDistance = distance
                closestColor = color
            }
        }
        
        return closestColor
    }
    

    private func clear(url: URL) {
        guard let uuid = executingTasks[url] else {
            return
        }
        
        executingTasks.removeValue(forKey: url)
        imageLoader.cancel(loadTaskWithId: uuid)
        
    }
    
}
