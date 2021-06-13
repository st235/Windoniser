import Foundation

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"

typealias AppearanceObserver = (SystemSupportedAppearanceType) -> Void

class SystemAppearanceController {
    
    private let appearanceInteractor: AppearanceInteractor
    private let providers: [AppearanceProvider]
    
    private var mode: AppearanceMode
    
    private var observers: [AppearanceObserver] = []
    
    var currentAppearance: SystemSupportedAppearanceType {
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
    
    init(appearanceInteractor: AppearanceInteractor) {
        self.appearanceInteractor = appearanceInteractor
        
        self.providers = [
            SystemAppearanceProvider(),
            SettingsAppearanceProvider(appearanceInteractor: appearanceInteractor)
        ]
        
        self.mode = appearanceInteractor.activeAppearance
        
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(self.onSystemAppearanceChanged(notification:)),
            name: NSNotification.Name(rawValue: kAppleInterfaceThemeChangedNotification),
            object: nil
        )
        
        self.appearanceInteractor.addDelegate(weak: self)
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

extension SystemAppearanceController: AppearanceInteractor.Delegate {
    
    func onAppearanceChanged(activeAppearance: AppearanceMode) {
        self.mode = activeAppearance
        self.notifyObservers()
    }
    
}
