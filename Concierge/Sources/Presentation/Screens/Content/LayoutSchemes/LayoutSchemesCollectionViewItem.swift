import Foundation

class LayoutSchemesCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var layoutSchemaPreviewView: LayoutSchemaPreviewView!
    
    private static let inActiveColor: NSColor = NSColor.from(name: .backgroundPrimary)
    private static let activeColor: NSColor = NSColor.from(name: .backgroundAccent)
    
    private let layoutSchemesIconFactory = LayoutSchemeIconsFactory()
    
    override func viewDidLoad() {
        layoutSchemaPreviewView.highlightColor = NSColor.from(name: .iconPrimary)
        view.wantsLayer = true
        view.layer?.backgroundColor = LayoutSchemesCollectionViewItem.inActiveColor.cgColor
        view.layer?.cornerRadius = 12
    }
    
    func load(scheme: LayoutSchema, isSelected: Bool) {
        layoutSchemaPreviewView.addLayoutPreviews(layoutSeparators: scheme.separators)
        if isSelected {
            select()
        } else {
            deselect()
        }
    }
    
    func select() {
        view.layer?.backgroundColor = LayoutSchemesCollectionViewItem.activeColor.cgColor
    }
    
    func deselect() {
        view.layer?.backgroundColor = LayoutSchemesCollectionViewItem.inActiveColor.cgColor
    }
    
}
