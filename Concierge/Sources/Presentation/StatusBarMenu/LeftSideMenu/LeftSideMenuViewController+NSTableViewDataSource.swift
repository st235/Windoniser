import Foundation

extension LeftSideMenuViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return activeWindows.count
    }
    
}
