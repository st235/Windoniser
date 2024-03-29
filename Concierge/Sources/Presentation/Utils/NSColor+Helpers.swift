import Foundation

extension NSColor.Name {
    static let backgroundPrimary = "BackgroundPrimary"
    static let backgroundTransparent = "BackgroundTransparent"
    static let backgroundAccent = "BackgroundAccent"
    
    static let strokePrimary = "StrokePrimary"
    
    static let textPrimary = "TextPrimary"
    static let textSecondary = "TextSecondary"
    static let textAccent = "TextAccent"
    
    static let iconPrimary = "IconPrimary"
    
    class Dynamic {
        static let iconAccent = "IconAccent"
    }
    
    class Static {
        static let white = "White"
        static let white30 = "White30"
        static let white75 = "White75"
        
        static let black = "Black"
        static let black75 = "Black75"
        
        static let darkGrey = "DarkGrey"
        
        static let grey = "Grey"
        static let grey40 = "Grey40"
    }
}

extension NSColor {
    
    public static func from(name: String) -> NSColor {
        guard let color = NSColor(named: NSColor.Name(name)) else {
            fatalError()
        }
        
        return color
    }
    
    // rgba
    public static func from(hex: String) -> NSColor {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    return NSColor(red: r, green: g, blue: b, alpha: a)
                }
            }
        }

        fatalError()
    }
    
    // rgba
    public func toHex() -> String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let alpha = Int(round(self.alphaComponent * 0xFF))
        
        let hexString = NSString(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
        
        return hexString as String
    }
}
