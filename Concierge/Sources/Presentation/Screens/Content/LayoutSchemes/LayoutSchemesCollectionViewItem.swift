import Foundation

class LayoutSchemesCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var layoutSchemaPreviewView: LayoutSchemaPreviewView!
    
    var rootView: CustomBackgroundView {
        get {
            return view as! CustomBackgroundView
        }
    }
    
    override func viewDidLoad() {
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
        layoutSchemaPreviewView.highlightColor = NSColor.from(name: .Dynamic.iconAccent)
        rootView.backgroundColor = NSColor.from(name: .backgroundAccent)
    }
    
    func deselect() {
        layoutSchemaPreviewView.highlightColor = NSColor.from(name: .iconPrimary)
        rootView.backgroundColor = NSColor.from(name: .backgroundPrimary)
    }
    
}
