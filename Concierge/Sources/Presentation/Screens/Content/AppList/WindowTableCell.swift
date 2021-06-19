import Foundation

class WindowTableCell: NSTableCellView {
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var subtitleView: NSTextField!
    @IBOutlet weak var activityDotView: NSImageView!
    
    var isActive: Bool {
        get {
            return !activityDotView.isHidden
        }
        set {
            activityDotView.isHidden = !newValue
        }
    }
    
}
