import Foundation

class SettingsTableAdapter: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    private let schemes: [LayoutScheme]
    var handler: ((LayoutScheme) -> Void)? = nil
    
    init(schemes: [LayoutScheme]) {
        self.schemes = schemes
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return schemes.count
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        handler?(schemes[row])
        return true
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SettingsTableViewCell"), owner: nil) as? SettingsTableViewCell else {
            return nil
        }
        
        let scheme = schemes[row]
        cell.scheme = scheme
        
        return cell
      }
    
}
