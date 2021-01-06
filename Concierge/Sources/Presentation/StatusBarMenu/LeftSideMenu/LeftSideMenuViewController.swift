import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController, LayoutPreviewView.Delegate {
    
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
        layoutPreviewView.registerForDraggedTypes([.windowPid])
        layoutPreviewView.delegate = self
        
        self.activeWindows = Array(windowRepository.allWindows())
        
        iconTableColumn.title = "left_side_menu_process_icon".localized
        processNameTableColumn.title = "left_side_menu_process_process".localized
        windowNameTableColumn.title = "left_side_menu_process_window".localized
        
        windowsTableView.dataSource = self
        windowsTableView.delegate = self
        windowsTableView.isEnabled = true
        
        windowsTableView.setDraggingSourceOperationMask(.copy, forLocal: false)
        
//        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0, y: 0, width: 0.5, height: 0.5))
//        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0.5, y: 0, width: 0.5, height: 0.5))
//        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0, y: 0.5, width: 0.5, height: 0.5))
//        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
        
        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0, y: 0, width: 1.0 / 3.0, height: 1.0))
        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 1.0 / 3.0, y: 0, width: 1.0 / 3.0, height: 1.0))
        self.layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 2.0 / 3.0, y: 0, width: 1.0 / 3.0, height: 1.0))
    }
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?) {
        let screenController = ScreensController(windowController: self.windowController)
        let reverse = NSRect(x: preview.minX, y: 1.0 - preview.height - preview.minY, width: preview.width, height: preview.height)
        print(preview)
        print(reverse)
        
        if let pids = payload as? [WindowPidPasteboard] {
            for pid in pids {
                let window = windowController.findWindow(byPid: pid.pid)
                screenController.resize(window: window, projection: reverse)
            }
        }
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
        return 21
    }
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        return WindowPidPasteboard(pid: activeWindows[row].pid)
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
