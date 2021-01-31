import Foundation

extension LeftSideMenuViewController: NSTableViewDelegate {
    
    private enum CellIdentifiers: String {
        case NameCell = "NameCellID"
        case AppCell = "AppCellID"
        case IconCell = "IconCellID"
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
        return 32
    }
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        let window = activeWindows[row]
        return WindowPasteboard(pid: window.pid, id: window.id)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn, let index = tableView.tableColumns.firstIndex(of: tableColumn) else {
            return nil
        }
        
        let id = getTableId(byPosition: index)
        let item = activeWindows[row]
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: id.rawValue), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        switch id {
        case .IconCell:
            cell.imageView?.image = item.icon
        case .AppCell:
            guard let owner = item.owner else {
                return nil
            }
            
            cell.textField?.stringValue = owner
        case .NameCell:
            cell.textField?.stringValue = item.title
        }
        
        return cell
      }
    
    private func getTableId(byPosition position: Int) -> CellIdentifiers {
        switch position {
        case 0:
            return .IconCell
        case 1:
            return .AppCell
        case 2:
            return .NameCell
        default:
            fatalError("Cannot find id for position \(position)")
        }
    }
    
}
