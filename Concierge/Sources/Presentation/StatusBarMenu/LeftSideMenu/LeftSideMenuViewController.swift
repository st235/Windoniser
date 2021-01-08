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
    private var prefferedLayoutScheme: LayoutScheme? = nil
    
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
    
    static func create(windowRepository: WindowRepository = AppDependenciesResolver.shared.resolve(type: WindowRepository.self),
                       layoutSchemesRepository: LayoutSchemesRepository = AppDependenciesResolver.shared.resolve(type: LayoutSchemesRepository.self),
                       screenController: ScreensController = AppDependenciesResolver.shared.resolve(type: ScreensController.self)) -> LeftSideMenuViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("LeftSideMenuViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? LeftSideMenuViewController else {
            fatalError("Check storyboard. Probably, id of view controller does not match with id below")
        }
        
        viewController.activeWindows = windowRepository.activeWindows()
        viewController.windowRepository = windowRepository
        viewController.screenController = screenController
        viewController.prefferedLayoutScheme = layoutSchemesRepository.providePreferredScheme()
        
        return viewController
    }
}
