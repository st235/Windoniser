import Foundation

class LayoutSchemesCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var layoutSchemaPreviewView: LayoutSchemaPreviewView!
    
    var rootView: CustomBackgroundView {
        get {
            return view as! CustomBackgroundView
        }
    }
    
    private let inActiveColor: NSColor = NSColor.from(name: .backgroundPrimary)
    private let activeColor: NSColor = NSColor.from(name: .backgroundAccent)
    
    private let layoutSchemesIconFactory = LayoutSchemeIconsFactory()
    
    override func viewDidLoad() {
        layoutSchemaPreviewView.highlightColor = NSColor.from(name: .iconPrimary)
        
        rootView.cornerRadius = 12
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
        rootView.backgroundColor = activeColor
    }
    
    func deselect() {
        rootView.backgroundColor = inActiveColor
    }
    
}
