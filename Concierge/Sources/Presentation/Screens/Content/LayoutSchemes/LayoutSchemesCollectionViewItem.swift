import Foundation

class LayoutSchemesCollectionViewItem: NSCollectionViewItem {
    
    private let inActiveColor: NSColor = NSColor.from(name: .backgroundPrimary)
    private let activeColor: NSColor = NSColor.from(name: .backgroundAccent)
    
    private let layoutSchemesIconFactory = LayoutSchemeIconsFactory()
    
    override func viewDidLoad() {
        view.wantsLayer = true
        view.layer?.backgroundColor = inActiveColor.cgColor
        view.layer?.cornerRadius = 12
    }
    
    func load(scheme: LayoutSchema) {
        let image = layoutSchemesIconFactory.findIconForScheme(scheme: scheme)
        image.isTemplate = true
        imageView?.image = image.image(with: NSColor.from(name: .iconPrimary))
    }
    
    func select() {
        view.layer?.backgroundColor = activeColor.cgColor
    }
    
    func deselect() {
        view.layer?.backgroundColor = inActiveColor.cgColor
    }
    
}
