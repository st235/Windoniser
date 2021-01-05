import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController {
    
    private let windowController = WindowController()
    private var activeWindows = [WindowRepository.WindowInfo]()
    
    @IBOutlet weak var layoutPreviewView: LayoutPreviewView!
    @IBOutlet weak var windowsTableView: NSTableView!
    @IBOutlet weak var windowNameTableColumn: NSTableColumn!
    @IBOutlet weak var iconTableColumn: NSTableColumn!
    @IBOutlet weak var processNameTableColumn: NSTableColumn!
    
    override func viewDidLoad() {
        let windowRepository = WindowRepository(windowController: self.windowController)
        layoutPreviewView.setBackgroundColor(backgroundColor: .white)
        
        self.activeWindows = Array(windowRepository.allWindows())
        
        iconTableColumn.title = "left_side_menu_process_icon".localized
        processNameTableColumn.title = "left_side_menu_process_process".localized
        windowNameTableColumn.title = "left_side_menu_process_window".localized
        
        windowsTableView.dataSource = self
        windowsTableView.delegate = self
    }
    
    static func create() -> LeftSideMenuViewController {
      let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
      let identifier = NSStoryboard.SceneIdentifier("LeftSideMenuViewController")
      guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LeftSideMenuViewController else {
        fatalError("Check storyboard. Probably, id of view controller does not match with id below")
      }
      return viewcontroller
    }
}

extension LeftSideMenuViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return activeWindows.count
    }
    
}

extension LeftSideMenuViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
      static let NameCell = "NameCellID"
      static let AppCell = "AppCellID"
      static let IconCell = "IconCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        var text: String = ""
        var icon: NSImage? = nil
        
        let item = activeWindows[row]
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            icon = item.icon
            cellIdentifier = CellIdentifiers.IconCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.owner ?? ""
            cellIdentifier = CellIdentifiers.AppCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.title
            cellIdentifier = CellIdentifiers.NameCell
        }

        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
          cell.textField?.stringValue = text
            cell.imageView?.image = icon
          return cell
        }
        return nil
      }
    
}
