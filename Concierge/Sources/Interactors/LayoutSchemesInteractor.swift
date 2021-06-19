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
        
        let schemas = layoutSchemesRepository.defaultSchemes
        
        for schema in schemas {
            if schema.isDefault {
                selectedItems.insert(schema.id)
            }
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
        selectedItems.insert(schema.id)
        settingsRepository.set(type: .selectedLayouts, value: Array(selectedItems))
        
        for delegate in delegates {
            delegate.onSelectedSchemasChanged()
        }
    }
    
    func unselectSchema(schema: LayoutSchema) {
        if schema.isUnselectable {
            return
        }
        
        if (activeSchema.id == schema.id) {
            activeSchema = layoutSchemesRepository.defaultSchema
        }
        
        selectedItems.remove(schema.id)
        
        if selectedItems.isEmpty {
            selectedItems.insert(layoutSchemesRepository.defaultSchema.id)
        }
        
        settingsRepository.set(type: .selectedLayouts, value: Array(selectedItems))
        
        for delegate in delegates {
            delegate.onSelectedSchemasChanged()
        }
    }
    
    func isSelected(schema: LayoutSchema) -> Bool {
        if schema.isUnselectable {
            // unselectable items are always selected
            return true
        }
        return selectedItems.contains(schema.id)
    }
    
    func selectedSchemas() -> [LayoutSchema] {
        var selectedSchemas: [LayoutSchema] = []
        
        for schema in selectedItems {
            guard let schema = layoutSchemesRepository.findSchema(byId: schema) else {
                continue
            }
            selectedSchemas.append(schema)
        }
        
        selectedSchemas.sort(by: { $0.id < $1.id })
        
        return selectedSchemas
    }
    
}
