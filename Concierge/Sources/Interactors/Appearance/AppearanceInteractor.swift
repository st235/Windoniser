import Foundation

protocol _AppearanceDelegate: AnyObject {
    func onAppearanceChanged(activeAppearance: AppearanceMode)
}

class AppearanceInteractor {
    
    public typealias Delegate = _AppearanceDelegate
    
    public var activeAppearance: AppearanceMode {
        get {
            return settingsRepository.get(type: .appearance) as AppearanceMode
        }
        
        set {
            settingsRepository.set(type: .appearance, value: newValue)
            for delegate in delegates {
                delegate.onAppearanceChanged(activeAppearance: newValue)
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
    
    func availableAppearances() -> [AppearanceMode] {
        return [.followSystem, .forceDark, .forceLight]
    }
    
}
