class GraphDependenciesContainer: DependenciesContainer {
    
    private var providers: [String:Handler] = [:]
    private var types: [String:DependencyQualifier] = [:]
    
    private var components: [String:Any] = [:]
    
    func register(forType type: Any, withProvider provider: @escaping Handler, andQualifier qualifier: DependencyQualifier) {
        let typeName = createName(forType: type)
        assert(providers[typeName] == nil, "You are trying to register the object, which is already initialized")
        providers[typeName] = provider
        types[typeName] = qualifier
    }
    
    func resolve<Component>(type: Any) -> Component {
        let typeName = createName(forType: type)
        
        guard let quialifier = types[typeName] else {
            fatalError("Cannot resolve qualifier for type \(typeName). Did you register it?")
        }
        
        assert(quialifier == .singleton || components[typeName] == nil, "Components cannot hold non singleton types, like \(typeName)")
        
        if quialifier == .singleton && components[typeName] != nil,
           let component = components[typeName] as? Component {
            return component
        }
        
        guard let provider = providers[typeName] else {
            fatalError("Cannot find provider for type \(typeName). Did you register it?")
        }

        guard let component = provider(self) as? Component else {
            fatalError("Provider doesnt not provider component with type \(typeName)")
        }
    
        if quialifier == .singleton {
            components[typeName] = component
        }
        
        return component
    }
        
    private func createName(forType type: Any) -> String {
        return String(reflecting: type)
    }
    
}
