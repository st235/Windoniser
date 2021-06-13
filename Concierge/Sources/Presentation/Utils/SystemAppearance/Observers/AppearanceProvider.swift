import Foundation

enum SystemSupportedAppearanceType {
    case light
    case dark
}

protocol AppearanceProvider {
    
    func canHandle(mode: AppearanceMode) -> Bool
    
    func fetch() -> SystemSupportedAppearanceType
    
}
