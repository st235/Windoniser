import Foundation

protocol _LayoutSchemesDelegate: AnyObject {
    func onActiveSchemeChanged(schemes: LayoutScheme)
}

class LayoutSchemesInteractor {
    
    public typealias Delegate = _LayoutSchemesDelegate
    
    public var activeScheme: LayoutScheme {
        get {
            return _activeScheme
        }
        
        set {
            _activeScheme = newValue
            for delegate in delegates {
                delegate.onActiveSchemeChanged(schemes: _activeScheme)
            }
        }
    }
    
    private var _activeScheme: LayoutScheme
    private let layoutSchemesRepository: LayoutSchemesRepository
    
    var delegates: [Delegate] = []
    
    init(layoutSchemesRepository: LayoutSchemesRepository) {
        self.layoutSchemesRepository = layoutSchemesRepository
        self._activeScheme = layoutSchemesRepository.providePreferredScheme()
    }
    
    func addDelegate(weak delegate: Delegate) {
        self.delegates.append(delegate)
    }
    
    func defaultSchemes() -> [LayoutScheme] {
        return layoutSchemesRepository.provideDefaultSchemes()
    }
    
}
