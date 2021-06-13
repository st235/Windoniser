import Foundation

protocol _LayoutSchemesDelegate: AnyObject {
    func onActiveSchemeChanged(schemes: LayoutSchema)
    func onSelectedSchemasChanged()
}

class LayoutSchemesInteractor {
    
    public typealias Delegate = _LayoutSchemesDelegate
    
    public var activeSchema: LayoutSchema {
        get {
            return layoutSchemesRepository.prefferedScheme
        }
        
        set {
            layoutSchemesRepository.prefferedScheme = newValue
            for delegate in delegates {
                delegate.onActiveSchemeChanged(schemes: newValue)
            }
        }
    }
    
    private let layoutSchemesRepository: LayoutSchemesRepository
    private let settingsRepository: SettingsRepository
    
    var delegates: [Delegate] = []
    var selectedItems: Set<Int>
    
    init(layoutSchemesRepository: LayoutSchemesRepository,
         settingsRepository: SettingsRepository) {
        self.layoutSchemesRepository = layoutSchemesRepository
        self.settingsRepository = settingsRepository
        
        self.selectedItems = Set(settingsRepository.get(type: .selectedLayouts) as [Int])
        
        if selectedItems.isEmpty {
            selectedItems.insert(layoutSchemesRepository.defaultSchema.type)
        }
    }
    
    func addDelegate(weak delegate: Delegate) {
        self.delegates.append(delegate)
    }
    
    func removeDelegate(weak delegate: Delegate) {
        self.delegates.removeAll(where: { $0 === delegate })
    }
    
    func defaultSchemes() -> [LayoutSchema] {
        return layoutSchemesRepository.defaultSchemes
    }
    
    func selectSchema(schema: LayoutSchema) {
        selectedItems.insert(schema.type)
        settingsRepository.set(type: .selectedLayouts, value: Array(selectedItems))
        
        for delegate in delegates {
            delegate.onSelectedSchemasChanged()
        }
    }
    
    func unselectSchema(schema: LayoutSchema) {
        if (!canBeUnselected(schema: schema)) {
            return
        }
        
        if (activeSchema.type == schema.type) {
            activeSchema = layoutSchemesRepository.defaultSchema
        }
        
        selectedItems.remove(schema.type)
        
        if selectedItems.isEmpty {
            selectedItems.insert(layoutSchemesRepository.defaultSchema.type)
        }
        
        settingsRepository.set(type: .selectedLayouts, value: Array(selectedItems))
        
        for delegate in delegates {
            delegate.onSelectedSchemasChanged()
        }
    }
    
    func canBeUnselected(schema: LayoutSchema) -> Bool {
        return schema.type != .fullscreen
    }
    
    func isSelected(schema: LayoutSchema) -> Bool {
        if (!canBeUnselected(schema: schema)) {
            // unselectable items are always selected
            return true
        }
        return selectedItems.contains(schema.type)
    }
    
    func selectedSchemas() -> [LayoutSchema] {
        var selectedSchemas: [LayoutSchema] = []
        
        for schema in selectedItems {
            selectedSchemas.append(layoutSchemesRepository.findSchema(byId: schema))
        }
        
        selectedSchemas.sort(by: { $0.type < $1.type })
        
        return selectedSchemas
    }
    
}
