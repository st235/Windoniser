import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController, LayoutPreviewView.Delegate {
        
    @IBOutlet weak var desktopLayoutView: DesktopLayoutView!
    @IBOutlet weak var windowsTableView: NSTableView!
    @IBOutlet weak var layoutSchemesCollectionView: NSCollectionView!
    
    var layoutSchemes: [LayoutScheme] = []
    var activeWindows: [WindowRepository.WindowInfo] = []
    var lastKnownIndexPath: IndexPath? = nil
    
    var layoutSchemesInteractor: LayoutSchemesInteractor? = nil
    private var windowInteractor: WindowInteractor? = nil
    
    override func viewDidLoad() {
        if let wallpaperURL = self.windowInteractor?.getFocusedDesktopImageURL() {
            desktopLayoutView.setImageAsync(fromUrl: wallpaperURL)
        }
        
        desktopLayoutView.layoutDelegate = self
        layoutSchemesInteractor?.addDelegate(weak: self)
                
        windowsTableView.headerView = nil
        windowsTableView.dataSource = self
        windowsTableView.delegate = self
        windowsTableView.isEnabled = true
        windowsTableView.setDraggingSourceOperationMask(.copy, forLocal: false)
        windowsTableView.backgroundColor = .clear
        windowsTableView.gridColor = .clear
        windowsTableView.selectionHighlightStyle = .none
        
        layoutSchemesCollectionView.dataSource = self
        layoutSchemesCollectionView.delegate = self
        layoutSchemesCollectionView.enclosingScrollView?.horizontalScroller?.alphaValue = 0.0
        layoutSchemesCollectionView.backgroundColors = [.clear]
        layoutSchemesCollectionView.isSelectable = true
        
        reloadActiveScheme()
    }
    
    override func viewWillDisappear() {
        layoutSchemesInteractor?.removeDelegate(weak: self)
    }
    
    func reloadActiveScheme() {
        desktopLayoutView.clearPreviews()
        
        guard let scheme = layoutSchemesInteractor?.activeScheme else {
            return
        }
        
        desktopLayoutView.addLayoutPreviews(layoutPreviews: scheme.areas.map({ $0.rect }), layoutSeparators: scheme.separators)
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
        viewController.layoutSchemes = layoutSchemesInteractor.defaultSchemes()
        
        viewController.layoutSchemesInteractor = layoutSchemesInteractor
        viewController.windowInteractor = windowInteractor
        
        return viewController
    }
}
