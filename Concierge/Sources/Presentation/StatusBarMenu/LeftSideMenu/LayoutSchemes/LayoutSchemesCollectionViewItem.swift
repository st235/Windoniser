import Foundation

class LayoutSchemesCollectionViewItem: NSCollectionViewItem {
    
    private let inActiveColor: NSColor = NSColor.from(name: .backgroundPrimary)
    
    override func viewDidLoad() {
        view.wantsLayer = true
        view.layer?.backgroundColor = inActiveColor.cgColor
        view.layer?.cornerRadius = 12
    }
    
    func load(iconName: String) {
        let image = NSImage(named: iconName)
        image?.isTemplate = true
        imageView?.image = image?.image(with: NSColor.from(name: .iconPrimary))
    }
    
}
