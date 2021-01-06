import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController, LayoutPreviewView.Delegate {
        
    @IBOutlet weak var layoutPreviewView: LayoutPreviewView!
    @IBOutlet weak var windowsTableView: NSTableView!
    @IBOutlet weak var windowNameTableColumn: NSTableColumn!
    @IBOutlet weak var iconTableColumn: NSTableColumn!
    @IBOutlet weak var processNameTableColumn: NSTableColumn!
    
    var activeWindows: [WindowRepository.WindowInfo] = []
    private var windowRepository: WindowRepository? = nil
    private var screenController: ScreensController? = nil
    
    override func viewDidLoad() {
        iconTableColumn.title = "left_side_menu_process_icon".localized
        processNameTableColumn.title = "left_side_menu_process_process".localized
        windowNameTableColumn.title = "left_side_menu_process_window".localized
        
        layoutPreviewView.backgroundColor = .white
        layoutPreviewView.registerForDraggedTypes([.windowPid])
        layoutPreviewView.setShadow(withOpacity: 1.0, andRadius: 20)
        layoutPreviewView.delegate = self
                
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
        guard let windowRepository = windowRepository, let screenController = screenController else {
            return
        }
        
        let reverse = NSRect(x: preview.minX, y: 1.0 - preview.height - preview.minY, width: preview.width, height: preview.height)

        if let pids = payload as? [WindowPidPasteboard] {
            for pid in pids {
                let window = windowRepository.findWindow(byPid: pid.pid)
                screenController.resize(window: window, projection: reverse)
            }
        }
    }
    
    static func create(windowRepository: WindowRepository, screenController: ScreensController) -> LeftSideMenuViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("LeftSideMenuViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? LeftSideMenuViewController else {
        fatalError("Check storyboard. Probably, id of view controller does not match with id below")
        }
        
        viewController.activeWindows = windowRepository.activeWindows()
        viewController.windowRepository = windowRepository
        viewController.screenController = screenController
        
        return viewController
    }
}
