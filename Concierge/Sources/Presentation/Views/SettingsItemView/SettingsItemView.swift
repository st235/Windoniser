import Foundation

class SettingsItemView: NSView, NibLoadable {
    
    @IBOutlet var contentView: NSView!
    @IBOutlet private weak var iconView: NSImageView!
    @IBOutlet private weak var textView: NSTextField!
    @IBOutlet private weak var arrowView: NSImageView!
    
    var clickHandler: (() -> Void)? = nil
    
    var isArrowShown: Bool {
        set {
            arrowView.isHidden = !newValue
        }
        get {
            return !arrowView.isHidden
        }
    }
    
    var text: String {
        set {
            textView.stringValue = newValue
        }
        get {
            return textView.stringValue
        }
    }
    
    var icon: NSImage? {
        set {
            iconView.isHidden = newValue == nil
            iconView.image = newValue
        }
        get {
            return iconView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadFromNib()
    }
    
    override func mouseUp(with event: NSEvent) {
        clickHandler?()
    }
    
}
