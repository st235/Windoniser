import Foundation

protocol _LayoutSchemesDelegate: AnyObject {
    func onActiveSchemeChanged(schemes: LayoutSchema)
    func onSelectedSchemasChanged()
}

class LayoutSchemesInteractor {
    
    public typealias Delegate = _LayoutSchemesDelegate
    
    public var activeScheme: LayoutSchema {
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
            selectedItems.insert(layoutSchemesRepository.defaultSchema.type.rawValue)
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
        selectedItems.insert(schema.type.rawValue)
        
        settingsRepository.set(type: .selectedLayouts, value: Array(selectedItems))
        
        for delegate in delegates {
            delegate.onSelectedSchemasChanged()
        }
    }
    
    func unselectSchema(schema: LayoutSchema) {
        selectedItems.remove(schema.type.rawValue)
        
        if selectedItems.isEmpty {
            selectedItems.insert(layoutSchemesRepository.defaultSchema.type.rawValue)
        }
        
        settingsRepository.set(type: .selectedLayouts, value: Array(selectedItems))
        
        for delegate in delegates {
            delegate.onSelectedSchemasChanged()
        }
    }
    
    func isSelected(schema: LayoutSchema) -> Bool {
        return selectedItems.contains(schema.type.rawValue)
    }
    
    func selectedSchemas() -> [LayoutSchema] {
        var selectedSchemas: [LayoutSchema] = []
        
        for schema in selectedItems {
            selectedSchemas.append(layoutSchemesRepository.findSchema(byId: schema))
        }
        
        selectedSchemas.sort(by: { $0.type.rawValue < $1.type.rawValue })
        
        return selectedSchemas
    }
    
}
