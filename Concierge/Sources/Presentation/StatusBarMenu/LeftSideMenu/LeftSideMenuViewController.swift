import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController, LayoutPreviewView.Delegate {
        
    @IBOutlet weak var layoutPreviewView: LayoutPreviewView!
    @IBOutlet weak var windowsTableView: NSTableView!
    @IBOutlet weak var windowNameTableColumn: NSTableColumn!
    @IBOutlet weak var iconTableColumn: NSTableColumn!
    @IBOutlet weak var processNameTableColumn: NSTableColumn!
    
    var activeWindows: [WindowRepository.WindowInfo] = []
    private var prefferedLayoutScheme: LayoutScheme? = nil
    private var windowInteractor: WindowInteractor? = nil
    
    override func viewDidLoad() {
        iconTableColumn.title = "left_side_menu_process_icon".localized
        processNameTableColumn.title = "left_side_menu_process_process".localized
        windowNameTableColumn.title = "left_side_menu_process_window".localized
        
        layoutPreviewView.backgroundColor = .white
        layoutPreviewView.registerForDraggedTypes([.windowPid])
        layoutPreviewView.setShadow(withOpacity: 1.0, andRadius: 20)
        layoutPreviewView.delegate = self
        
        layoutPreviewView.inactiveColor = .gray
        layoutPreviewView.highlightColor = .darkGray
                
        windowsTableView.dataSource = self
        windowsTableView.delegate = self
        windowsTableView.isEnabled = true
        windowsTableView.setDraggingSourceOperationMask(.copy, forLocal: false)

        initializePrefferedLayoutScheme()
    }
    
    private func initializePrefferedLayoutScheme() {
        guard let scheme = prefferedLayoutScheme else {
            return
        }
        
        for area in scheme.areas {
            layoutPreviewView.addLayoutPreview(layoutPreview: area.rect)
        }
    }
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?) {
        guard let windowPids = payload as? [WindowPasteboard] else {
            fatalError("Copied payload is not a pid pasteboard")
        }
        
        assert(windowPids.count == 1, "Pids have more (or less) than 1 object. Count is \(windowPids.count)")
        
        if let windowPid = windowPids.first {
            windowInteractor?.resizeWindow(withPid: windowPid.pid, andId: windowPid.id, into: preview)
        }
    }
    
    static func create(windowInteractor: WindowInteractor = AppDependenciesResolver.shared.resolve(type: WindowInteractor.self),
                       layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)) -> LeftSideMenuViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("LeftSideMenuViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? LeftSideMenuViewController else {
            fatalError("Check storyboard. Probably, id of view controller does not match with id below")
        }
        
        viewController.activeWindows = windowInteractor.activeWindows()
        viewController.windowInteractor = windowInteractor
        viewController.prefferedLayoutScheme = layoutSchemesInteractor.activeScheme
        
        return viewController
    }
}
