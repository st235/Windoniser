import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController, LayoutPreviewView.Delegate {
        
    @IBOutlet weak var desktopLayoutView: DesktopLayoutView!
    @IBOutlet weak var windowsTableView: NSTableView!
    @IBOutlet weak var layoutSchemesCollectionView: NSCollectionView!
    @IBOutlet weak var settingsButton: NSButton!
    
    var lastKnownIndexPath: IndexPath? = nil
    
    private let windowInteractor: WindowInteractor = AppDependenciesResolver.shared.resolve(type: WindowInteractor.self)
    private let layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)
    private let appListTableViewAdapter: AppListTableViewAdapter
    
    required init?(coder: NSCoder) {
        appListTableViewAdapter = AppListTableViewAdapter(activeWindows: windowInteractor.activeWindows())
        super.init(coder: coder)
    }
    
    var layoutSchemes: [LayoutScheme] {
        get {
            return layoutSchemesInteractor.defaultSchemes()
        }
    }
    
    var activeScheme: LayoutScheme {
        get {
            return layoutSchemesInteractor.activeScheme
        }
        set(newValue) {
            layoutSchemesInteractor.activeScheme = newValue
        }
    }
    
    override func viewDidLoad() {
        if let wallpaperURL = self.windowInteractor.getFocusedDesktopImageURL() {
            desktopLayoutView.setImageAsync(fromUrl: wallpaperURL)
        }
        
        desktopLayoutView.layoutDelegate = self
        layoutSchemesInteractor.addDelegate(weak: self)
                
        windowsTableView.headerView = nil
        windowsTableView.dataSource = appListTableViewAdapter
        windowsTableView.delegate = appListTableViewAdapter
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
        
        settingsButton.target = self
        settingsButton.action = #selector(onSettingsClick(_:))
        
        reloadActiveScheme()
    }
    
    @objc private func onSettingsClick(_ sender: Any?) {
        (parent as? Navigatable)?.push(controllerId: .settings)
    }
    
    func reloadActiveScheme() {
        desktopLayoutView.clearPreviews()
        let scheme = activeScheme
        desktopLayoutView.addLayoutPreviews(layoutPreviews: scheme.areas.map({ $0.rect }), layoutSeparators: scheme.separators)
    }
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?) {
        guard let windowPids = payload as? [WindowPasteboard] else {
            fatalError("Copied payload is not a pid pasteboard")
        }
        
        assert(windowPids.count == 1, "Pids have more (or less) than 1 object. Count is \(windowPids.count)")
        
        if let windowPid = windowPids.first {
            windowInteractor.resizeWindow(withPid: windowPid.pid, andId: windowPid.id, into: preview)
        }
    }
}
