import Foundation

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"

typealias AppearanceObserver = (SystemSupportedAppearanceType) -> Void

class SystemAppearanceController {
    
    private let appearanceInteractor: AppearanceInteractor
    private let providers: [AppearanceProvider]
    
    private var mode: AppearanceMode
    private var appearnceObserver: NSKeyValueObservation? = nil
    
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
        
        appearnceObserver = NSApp.observe(\.effectiveAppearance, options: [.new, .old, .initial, .prior]) { app, change in
            self.onSystemAppearanceChanged()
        }
        
        self.appearanceInteractor.addDelegate(weak: self)
        self.changeGlobalAppearance()
    }
    
    @objc private func onSystemAppearanceChanged() {
        DispatchQueue.main.async {
            if self.mode == .followSystem {
                self.changeGlobalAppearance()
                self.notifyObservers()
            }
        }
    }
    
    func addObserver(observer: @escaping AppearanceObserver) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer(currentAppearance)
        }
    }
    
    private func changeGlobalAppearance() {
        NSAppearance.current = NSAppearance(named: systemAppearance)!
    }
    
    deinit {
        NSApp.removeObserver(appearnceObserver!, forKeyPath: "effectiveAppearance")
    }
    
}

extension SystemAppearanceController: AppearanceInteractor.Delegate {
    
    func onAppearanceChanged(activeAppearance: AppearanceMode) {
        self.mode = activeAppearance
        self.changeGlobalAppearance()
        self.notifyObservers()
    }
    
}
