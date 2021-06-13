import Foundation

class LayoutSchemesCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var layoutSchemaPreviewView: LayoutSchemaPreviewView!
    
    private let inActiveColor: NSColor = NSColor.from(name: .backgroundPrimary)
    private let activeColor: NSColor = NSColor.from(name: .backgroundAccent)
    
    private let layoutSchemesIconFactory = LayoutSchemeIconsFactory()
    
    override func viewDidLoad() {
        layoutSchemaPreviewView.highlightColor = NSColor.from(name: .iconPrimary)
        view.wantsLayer = true
        view.layer?.backgroundColor = inActiveColor.cgColor
        view.layer?.cornerRadius = 12
    }
    
    func load(scheme: LayoutSchema) {
//        let image = layoutSchemesIconFactory.findIconForScheme(scheme: scheme)
//        image.isTemplate = true
//        imageView?.image = image.image(with: NSColor.from(name: .iconPrimary))
        layoutSchemaPreviewView.addLayoutPreviews(layoutSeparators: scheme.separators)
    }
    
    func select() {
        view.layer?.backgroundColor = activeColor.cgColor
    }
    
    func deselect() {
        view.layer?.backgroundColor = inActiveColor.cgColor
    }
    
}
