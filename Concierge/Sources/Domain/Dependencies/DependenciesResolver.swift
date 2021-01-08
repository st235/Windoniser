protocol DependenciesResolver {
    
    func resolve<Component>(type: Any) -> Component
    
}
