import Foundation

private let kAppleInterfaceStyleSwitchesAutomatically = "AppleInterfaceStyleSwitchesAutomatically"
private let kAppleInterfaceStyle = "AppleInterfaceStyle"

class SystemAppearanceProvider: AppearanceProvider {
    
    
    func canHandle(mode: AppearanceMode) -> Bool {
        return mode == .followSystem
    }
    
    func fetch() -> SystemSupportedAppearanceType {
        if #available(OSX 10.15, *) {
            let appearanceDescription = NSApplication.shared.effectiveAppearance.debugDescription.lowercased()
            if appearanceDescription.contains("dark") {
                return .dark
            }
        } else if #available(OSX 10.14, *) {
            if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
                if appleInterfaceStyle.lowercased().contains("dark") {
                    return .dark
                }
            }
        }
        return .light
    }
    
}
