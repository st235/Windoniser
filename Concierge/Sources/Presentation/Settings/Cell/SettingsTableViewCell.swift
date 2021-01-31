import Foundation

class SettingsTableViewCell: NSTableCellView {
    
    @IBOutlet weak var layoutScheme: LayoutPreviewView!
    @IBOutlet weak var schemeTitle: NSTextField!
    @IBOutlet weak var schemeDescription: NSTextField!
    
    var scheme: LayoutScheme? {
        didSet {
            guard let value = scheme else {
                fatalError()
            }
            
            schemeTitle.stringValue = value.title
            
            for area in value.areas {
                layoutScheme.addLayoutPreview(layoutPreview: area.rect)
            }
        }
    }
    
}
