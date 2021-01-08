protocol DependenciesContainer: DependenciesResolver {
    
    typealias Handler = (DependenciesResolver) -> Any
    
    func register(forType type: Any, withProvider provider: @escaping Handler, andQualifier qualifier: DependencyQualifier)
    
}

extension DependenciesContainer {
    
    func register(forType type: Any, _ provider: @escaping Handler) {
        register(forType: type, withProvider: provider, andQualifier: .factory)
    }
    
    func register(forType type: Any, andQualifier qualifier: DependencyQualifier, _ provider: @escaping Handler) {
        register(forType: type, withProvider: provider, andQualifier: qualifier)
    }
    
}

