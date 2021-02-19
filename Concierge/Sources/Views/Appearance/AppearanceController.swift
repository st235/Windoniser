import Foundation

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"

typealias AppearanceObserver = (AppearanceType) -> Void

class AppearanceController {
    
    private let settingsManager: SettingsManager
    private let providers: [AppearanceProvider]
    
    private var mode: AppearanceMode
    
    private var observers: [AppearanceObserver] = []
    
    var currentAppearance: AppearanceType {
        get {
            providers.first(where: { $0.canHandle(mode: mode) })?.fetch() ?? .light
        }
    }
    
    var systemAppearance: NSAppearance.Name {
        get {
            switch currentAppearance {
            case .light:
                return .aqua
            case .dark:
                return .darkAqua
            }
        }
    }
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        
        self.providers = [
            SystemAppearanceProvider(),
            SettingsAppearanceProvider(settingsManager: settingsManager)
        ]
        
        self.mode = settingsManager.get(type: .appearance)
        
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(self.onSystemAppearanceChanged(notification:)),
            name: NSNotification.Name(rawValue: kAppleInterfaceThemeChangedNotification),
            object: nil
        )
        
        settingsManager.addObserver(type: .appearance, observer: { [weak self] rawValue in
            self?.mode = rawValue as! AppearanceMode
        })
    }
    
    @objc private func onSystemAppearanceChanged(notification: Notification) {
        // it is workaround to wait until changes will be applied within system
        // before trigger actual value
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if self.mode == .followSystem {
                self.notifyObservers()
            }
        })
    }
    
    func addObserver(observer: @escaping AppearanceObserver) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer(currentAppearance)
        }
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(
            self,
            name: NSNotification.Name(rawValue: kAppleInterfaceThemeChangedNotification),
            object: nil
        )
    }
    
}
