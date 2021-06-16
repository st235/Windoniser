import Foundation

class KeySchemeView: NSView, NibLoadable {
    
    
    @IBOutlet var contentView: NSView!
    @IBOutlet weak var changeButton: NSButton!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var keySchemaLabel: NSTextField!
    
    var clickHandler: (() -> Void)? = nil
    
    var text: String {
        set {
            label.stringValue = newValue
        }
        get {
            return label.stringValue
        }
    }
    
    var rightButtonText: String {
        set {
            changeButton.title = newValue
        }
        get {
            return changeButton.title
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
        
        keySchemaLabel.wantsLayer = true
        keySchemaLabel.layer?.backgroundColor = hotkeyBackgroundColor.cgColor
        keySchemaLabel.layer?.cornerRadius = 4
        keySchemaLabel.textColor = hotkeyTextColor
        
        changeButton.action = #selector(onChangeClick(_:))
        changeButton.target = self
    }
    
    func setKeys(keys: [Key]) {
        keySchemaLabel.stringValue = keys.map() { $0.description }.joined()
    }

    
    private func preapreViewForKey(key: Key) -> NSTextField {
        let textField = NSTextField()
        
        textField.isEditable = false
        textField.backgroundColor = .none
        textField.textColor = .black
        textField.stringValue = key.description
        textField.font = NSFont.systemFont(ofSize: 16)
        
        return textField
    }
    
    @objc private func onChangeClick(_ sender: Any?) {
        clickHandler?()
    }
    
}
