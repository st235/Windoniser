import Foundation

class AppListTableViewAdapter: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    private let activeWindows: [WindowRepository.WindowInfo]
    
    init(activeWindows: [WindowRepository.WindowInfo]) {
        self.activeWindows = activeWindows
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return activeWindows.count
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return WindowTableRow()
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
        session.enumerateDraggingItems(options: .concurrent, for: tableView, classes: [NSPasteboardItem.self], searchOptions: [:], using: { item, index, _ in
            item.imageComponentsProvider = { [weak self] in
                guard let self = self, let index = rowIndexes.first else {
                    return []
                }

                let image = self.activeWindows[index].icon
                let component = NSDraggingImageComponent(key: .icon)
                component.contents = image
                component.frame = NSRect(x: 0, y: 0, width: 56, height: 56)
                return [component]
            }
        })
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        let window = activeWindows[row]
        return WindowPasteboard(pid: window.pid, id: window.id)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = activeWindows[row]
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "WindowTableCell"), owner: nil) as? WindowTableCell else {
            return nil
        }
        
        cell.iconView.image = item.icon
        cell.titleView.stringValue = item.title
        
        if let owner = item.owner {
            cell.subtitleView.stringValue = owner
        } else {
            cell.subtitleView.isHidden = true
        }
        
        return cell
      }
    
}
