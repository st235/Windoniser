import Foundation

protocol _LayoutSchemesDelegate: AnyObject {
    func onActiveSchemeChanged(schemes: LayoutScheme)
}

class LayoutSchemesInteractor {
    
    public typealias Delegate = _LayoutSchemesDelegate
    
    public var activeScheme: LayoutScheme {
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
    
    var delegates: [Delegate] = []
    
    init(layoutSchemesRepository: LayoutSchemesRepository) {
        self.layoutSchemesRepository = layoutSchemesRepository
    }
    
    func addDelegate(weak delegate: Delegate) {
        self.delegates.append(delegate)
    }
    
    func removeDelegate(weak delegate: Delegate) {
        self.delegates.removeAll(where: { $0 === delegate })
    }
    
    func defaultSchemes() -> [LayoutScheme] {
        return layoutSchemesRepository.defaultSchemes
    }
    
}
