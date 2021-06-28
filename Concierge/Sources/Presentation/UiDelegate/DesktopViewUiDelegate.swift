import Foundation

class DesktopViewUiDelegate: UiDelegate {
    
    private let header: NSTextField
    private let content: DesktopLayoutView
    
    private let windowInteractor: WindowInteractor
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    private let gridLayoutInteractor: GridLayoutInteractor
    
    var  onPreviewSelected: ((LayoutPreviewView.LayoutPreview, Any?) -> Void)? = nil
    
    init(header: NSTextField,
         content: DesktopLayoutView,
         windowInteractor: WindowInteractor,
         layoutSchemesInteractor: LayoutSchemesInteractor,
         gridLayoutInteractor: GridLayoutInteractor) {
        self.header = header
        self.content = content
        self.windowInteractor = windowInteractor
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.gridLayoutInteractor = gridLayoutInteractor
    }
    
    func update() {
        updateHeader()
        updateContent()
        
        layoutSchemesInteractor.addDelegate(weak: self)
        gridLayoutInteractor.addDelegate(weak: self)
    }
    
    private func updateHeader() {
        header.stringValue = "content_descktop_view_title".localized
    }
    
    private func updateContent() {
        if let wallpaperURL = self.windowInteractor.getFocusedDesktopImageURL() {
            content.setImageAsync(fromUrl: wallpaperURL)
        }
        
        content.layoutDelegate = self
        
        reloadActiveScheme()
        reloadGridTheme(activeTheme: gridLayoutInteractor.activeTheme)
    }
    
    private func reloadActiveScheme() {
        content.clearPreviews()
        let scheme = layoutSchemesInteractor.activeSchema
        content.addLayoutPreviews(layoutPreviews: scheme.areas.map({ LayoutPreviewView.LayoutPreview(id: $0.activeKey.description, origin: $0.rect) }), layoutSeparators: scheme.separators)
    }
    
    private func reloadGridTheme(activeTheme: GridTheme) {
        switch activeTheme {
        case .followSystem:
            content.changeGridTheme(backgroundColor: .backgroundTransparent, borderColor: .strokePrimary, highlightColor: .backgroundAccent, symbolsColor: .textPrimary)
        case .light:
            content.changeGridTheme(backgroundColor: .Static.white30, borderColor: .Static.white, highlightColor: .Static.grey, symbolsColor: .Static.black)
        case .dark:
            content.changeGridTheme(backgroundColor: .Static.grey40, borderColor: .Static.grey, highlightColor: .Static.white, symbolsColor: .Static.white)
        }
    }
    
}

extension DesktopViewUiDelegate: LayoutPreviewView.Delegate {
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?) {
        onPreviewSelected?(preview, payload)
    }
    
}

extension DesktopViewUiDelegate: LayoutSchemesInteractor.Delegate {
    
    func onActiveSchemeChanged(schemes: LayoutSchema) {
        reloadActiveScheme()
    }
    
    func onSelectedSchemasChanged() {
        reloadActiveScheme()
    }
    
}

extension DesktopViewUiDelegate: GridLayoutInteractor.Delegate  {
    
    func onGridColorChanged(theme: GridTheme) {
        reloadGridTheme(activeTheme: theme)
    }
    
}
