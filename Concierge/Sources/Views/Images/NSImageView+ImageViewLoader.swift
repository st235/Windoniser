import Foundation

extension NSImageView {
    
    func setImageAsync(fromUrl url: URL) {
        ImageViewLoader.shared.load(url: url, into: self)
    }
    
    func cancelLoadingView() {
        ImageViewLoader.shared.cancel(forView: self)
    }
    
}
