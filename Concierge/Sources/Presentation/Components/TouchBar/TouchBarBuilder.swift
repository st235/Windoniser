import Foundation

class TouchBarBuilder: NSObject, LayoutSchemesInteractor.Delegate, NSTouchBarDelegate {
    
    private static let rootIdentifier = NSTouchBarItem.Identifier("com.github.st235.tb.root")
    
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    private let windowInteractor: WindowInteractor
    
    private var activeSchema: LayoutSchema
    private var lastKnownUsedAreas: [NSTouchBarItem.Identifier:LayoutArea] = [:]
    
    init(layoutSchemesInteractor: LayoutSchemesInteractor,
         windowInteractor: WindowInteractor) {
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.activeSchema = self.layoutSchemesInteractor.activeSchema
        self.windowInteractor = windowInteractor
        
        super.init()
        
        self.layoutSchemesInteractor.addDelegate(weak: self)
    }
    
    func attach() {
        rebuildAciveMenu()
    }
    
    func onActiveSchemeChanged(schemes: LayoutSchema) {
        self.activeSchema = self.layoutSchemesInteractor.activeSchema
        rebuildAciveMenu()
    }
    
    func onSelectedSchemasChanged() {
        // empty on purpose
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let area = lastKnownUsedAreas[identifier] else {
            fatalError()
        }
        
        let areaSnapshot = LayoutSchemaRenderer.render(layoutSchema: activeSchema, strokeColor: .white, highlightedArea: area.rect, highlightColor: .white)
        let button = ActionButton()
        
        button.bezelStyle = .rounded
        button.image = areaSnapshot
        
        button.actionHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.windowInteractor.resizeFocusedWindow(intoRect: area.rect)
        }
        
        let item = NSCustomTouchBarItem(identifier: identifier)
        item.view = button
        
        return item
    }
    
    private func rebuildAciveMenu() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)

        let rootItem = NSCustomTouchBarItem(identifier: TouchBarBuilder.rootIdentifier)
        rootItem.view = NSButton(image: LayoutSchemaRenderer.render(layoutSchema: self.activeSchema, highlightColor: .white), target: self, action: #selector(onRootClicked(_:)))

        NSTouchBarItem.addSystemTrayItem(rootItem)
        
        DFRElementSetControlStripPresenceForIdentifier(TouchBarBuilder.rootIdentifier, true)
    }
    
    private func createSubmenuForActiveSchema() -> NSTouchBar {
        var ids: [NSTouchBarItem.Identifier] = []
        lastKnownUsedAreas.removeAll()
        
        for area in activeSchema.areas {
            let id = NSTouchBarItem.Identifier("com.github.st235.tb.id\(area.rawKey)")
            
            lastKnownUsedAreas[id] = area
            ids.append(id)
        }
        
        let touchbar = NSTouchBar()
        
        touchbar.delegate = self
        touchbar.defaultItemIdentifiers = ids
        
        return touchbar
    }
    
    @objc private func onRootClicked(_ sender: Any?) {
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(createSubmenuForActiveSchema(), systemTrayItemIdentifier: TouchBarBuilder.rootIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(createSubmenuForActiveSchema(), systemTrayItemIdentifier: TouchBarBuilder.rootIdentifier)
        }
    }
    
}
