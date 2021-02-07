import Foundation

class DesktopLayoutView: NSImageView {
    
    private let verticalPadding = CGFloat(12)
    private let horizontalPadding = CGFloat(12)
    
    private lazy var layoutPreviewView: LayoutPreviewView = {
        let layoutPreviewView = LayoutPreviewView()
        
        layoutPreviewView.backgroundColor = NSColor.from(name: .backgroundTransparent)
        layoutPreviewView.borderColor = NSColor.from(name: .strokePrimary)
        layoutPreviewView.highlightColor = NSColor.from(name: .backgroundAccent)
        
        layoutPreviewView.registerForDraggedTypes([.windowPid])
        
        return layoutPreviewView
    }()
    
    override var image: NSImage? {
            set {
                self.layer?.contents = newValue
                super.image = newValue
            }
            
            get {
                return super.image
            }
        }
     
    
    var layoutDelegate: LayoutPreviewView.Delegate? {
        get {
            return layoutPreviewView.delegate
        }
        set {
            layoutPreviewView.delegate = newValue
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubViews()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubViews()
        setup()
    }
    
    private func setup() {
        self.layer = CALayer()
        self.layer?.contentsGravity = .resizeAspectFill
        self.layer?.masksToBounds = true
        self.layer?.cornerRadius = 12
        self.wantsLayer = true
    }
    
    private func addSubViews() {
        addSubview(layoutPreviewView)
        
        layoutPreviewView.translatesAutoresizingMaskIntoConstraints = false
        layoutPreviewView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding).isActive = true
        layoutPreviewView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding).isActive = true
        layoutPreviewView.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalPadding).isActive = true
        layoutPreviewView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding).isActive = true
    }
    
    func addLayoutPreviews(layoutPreviews: [LayoutPreviewView.LayoutPreview], layoutSeparators: [LayoutPreviewView.LayoutSeparator]) {
        layoutPreviewView.addLayoutPreviews(layoutPreviews: layoutPreviews, layoutSeparators: layoutSeparators)
    }
    
}
