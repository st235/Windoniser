import Foundation

class SwitcherItemView: NSView, NibLoadable {
    
    @IBOutlet var contentView: NSView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var switcher: NSSwitch!
    
    var clickHandler: ((Bool) -> Void)? = nil
    
    var title: String {
        set {
            titleLabel.stringValue = newValue
        }
        get {
            return titleLabel.stringValue
        }
    }
    
    var state: Bool {
        set {
            if newValue {
                switcher.state = .on
            } else {
                switcher.state = .off
            }
        }
        get {
            return switcher.state == .on ? true : false
        }
    }
    
    var hotkeyBackgroundColor: NSColor = .gray
    
    var hotkeyTextColor: NSColor = .white
    
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

        switcher.target = self
        switcher.action = #selector(onChangeClick(_:))
    }
    
    override func mouseUp(with event: NSEvent) {
        state = !state
        onChangeClick(nil)
    }

    @objc private func onChangeClick(_ sender: Any?) {
        clickHandler?(state)
    }
    
}
