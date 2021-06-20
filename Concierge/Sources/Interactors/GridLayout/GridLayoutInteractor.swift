import Foundation

protocol _GridLayoutDelegate: AnyObject {
    func onGridColorChanged(theme: GridTheme)
}

class GridLayoutInteractor {
    
    public typealias Delegate = _GridLayoutDelegate
    
    public var activeTheme: GridTheme {
        get {
            return settingsRepository.get(type: .gridColor)
        }
        
        set {
            settingsRepository.set(type: .gridColor, value: newValue)
            for delegate in delegates {
                delegate.onGridColorChanged(theme: newValue)
            }
        }
    }
    
    private let settingsRepository: SettingsRepository
    
    var delegates: [Delegate] = []
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    func addDelegate(weak delegate: Delegate) {
        self.delegates.append(delegate)
    }
    
    func removeDelegate(weak delegate: Delegate) {
        self.delegates.removeAll(where: { $0 === delegate })
    }
    
    func availableGridThemes() -> [GridTheme] {
        return [.followSystem, .dark, .light]
    }
    
}
