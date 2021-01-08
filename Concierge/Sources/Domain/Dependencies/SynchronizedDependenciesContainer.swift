class SynchronizedDependenciesContainer: DependenciesContainer {
    
    private let diContainer: DependenciesContainer
    private let lock: NSRecursiveLock
    
    private init(diContainer: DependenciesContainer) {
        self.diContainer = diContainer
        self.lock = NSRecursiveLock()
    }
    
    func register(forType type: Any, withProvider provider: @escaping Handler, andQualifier qualifier: DependencyQualifier) {
        lock.lock()
        diContainer.register(forType: type, withProvider: provider, andQualifier: qualifier)
        lock.unlock()
    }
    
    func resolve<Component>(type: Any) -> Component {
        lock.lock()
        let result: Component = diContainer.resolve(type: type)
        lock.unlock()
        return result
    }
    
    static func proxy(diContainer: DependenciesContainer) -> DependenciesContainer {
        return SynchronizedDependenciesContainer(diContainer: diContainer)
    }
}
