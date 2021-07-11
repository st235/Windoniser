import Foundation

class  ActionButton: NSButton {
    
    var actionHandler: (() -> Void)? = nil
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.target = self
        self.action = #selector(onAction(_:))
    }
    
    @objc private func onAction(_ sender: Any?) {
        actionHandler?()
    }
    
}
