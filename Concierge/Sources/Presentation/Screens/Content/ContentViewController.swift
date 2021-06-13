import Foundation
import AppKit

class ContentViewController: NSViewController {
        
    @IBOutlet weak var desktopLayoutHeader: NSTextField!
    @IBOutlet weak var desktopLayoutView: DesktopLayoutView!
    
    @IBOutlet weak var windowsTableView: NSTableView!
    @IBOutlet weak var layoutSchemesCollectionView: NSCollectionView!
    @IBOutlet weak var settingsButton: NSButton!
    
    var lastKnownIndexPath: IndexPath? = nil
    
    private let windowInteractor: WindowInteractor = AppDependenciesResolver.shared.resolve(type: WindowInteractor.self)
    private let layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)
    private let gridLayoutInteractor: GridLayoutInteractor = AppDependenciesResolver.shared.resolve(type: GridLayoutInteractor.self)
    
    private lazy var desktopViewUiDelegate = {
        DesktopViewUiDelegate(header: desktopLayoutHeader, content: desktopLayoutView, windowInteractor: windowInteractor, layoutSchemesInteractor: layoutSchemesInteractor, gridLayoutInteractor: gridLayoutInteractor)
    }()
    
    private let appListTableViewAdapter: AppListTableViewAdapter
    
    required init?(coder: NSCoder) {
        appListTableViewAdapter = AppListTableViewAdapter(activeWindows: windowInteractor.activeWindows())
        super.init(coder: coder)
    }
    
    var layoutSchemes: [LayoutSchema] {
        get {
            return layoutSchemesInteractor.selectedSchemas()
        }
    }
    
    var activeScheme: LayoutSchema {
        get {
            return layoutSchemesInteractor.activeSchema
        }
        set(newValue) {
            layoutSchemesInteractor.activeSchema = newValue
        }
    }
    
    override func viewDidLoad() {
        layoutSchemesInteractor.addDelegate(weak: self)
        
        desktopViewUiDelegate.update()
        desktopViewUiDelegate.onPreviewSelected = { [weak self] preview, payload in
            self?.onPreviewSelected(preview: preview, payload: payload)
        }
                
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
    }
    
    @objc private func onSettingsClick(_ sender: Any?) {
        (parent as? Navigatable)?.push(controllerId: .settings, bundle: nil)
    }
    
    private func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?) {
        guard let windowPids = payload as? [WindowPasteboard] else {
            fatalError("Copied payload is not a pid pasteboard")
        }
        
        assert(windowPids.count == 1, "Pids have more (or less) than 1 object. Count is \(windowPids.count)")
        
        if let windowPid = windowPids.first {
            windowInteractor.resizeWindow(withPid: windowPid.pid, andId: windowPid.id, into: preview.origin)
        }
    }
    
}

extension ContentViewController: LayoutSchemesInteractor.Delegate {
    
    func onActiveSchemeChanged(schemes: LayoutSchema) {
        // empty on purpose
    }
    
    func onSelectedSchemasChanged() {
        layoutSchemesCollectionView.reloadData()
    }
    
}
