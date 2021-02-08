import Foundation

class LayoutSchemeIconsFactory {
    
    func findIconForScheme(scheme: LayoutScheme) -> NSImage {
        let iconReference = findIconRefForScheme(scheme: scheme)
        guard let icon = NSImage(named: NSImage.Name(iconReference)) else {
            fatalError()
        }
        
        return icon
    }
    
    private func findIconRefForScheme(scheme: LayoutScheme) -> String {
       switch scheme.type {
           case .fullscreen: return "Fullscreen"
           case .twoVertical: return "TwoVertical"
           case .twoHoriontal: return "TwoHorizontal"
           case .threeVertical: return "ThreeVertical"
           case .quadro: return "Quadro"
           default: return "Custom"
       }
    }
 
}
