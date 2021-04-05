import Foundation

enum AppearanceType {
    case light
    case dark
}

protocol AppearanceProvider {
    
    func canHandle(mode: AppearanceMode) -> Bool
    
    func fetch() -> AppearanceType
    
}
