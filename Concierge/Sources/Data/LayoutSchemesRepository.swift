import Foundation

class LayoutSchemesRepository {
    
    func providePreferredScheme() -> LayoutScheme {
        return LayoutScheme(title: "Custom", areas: [
            LayoutArea(title: "Left", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
            LayoutArea(title: "Right-Top", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)),
            LayoutArea(title: "Right-Bottom", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
            
//            LayoutArea(title: "Left", activeKey: .l, modifiers: [.shift, .command], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
//            LayoutArea(title: "Right", activeKey: .r, modifiers: [.shift, .command], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
        ])
    }
    
    func provideDefaultSchemes() -> [LayoutScheme] {
        var schemes = [LayoutScheme]()
        
        schemes.append(
            LayoutScheme(title: "Fullscreen", areas: [
                LayoutArea(title: "Main", activeKey: .f, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 1, height: 1))
            ])
        )
        
        schemes.append(
            LayoutScheme(title: "Two vertical sides", areas: [
                LayoutArea(title: "Left", activeKey: .l, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
                LayoutArea(title: "Right", activeKey: .r, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
            ])
        )
        
        schemes.append(
            LayoutScheme(title: "Two horizontal sides", areas: [
                LayoutArea(title: "Top", activeKey: .t, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 1, height: 0.5)),
                LayoutArea(title: "Bottom", activeKey: .b, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0.5, width: 1, height: 0.5))
            ])
        )
        
        schemes.append(
            LayoutScheme(title: "Three sides", areas: [
                LayoutArea(title: "First", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: (1.0/3.0), height: 1)),
                LayoutArea(title: "Second", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 1.0 / 3.0, y: 0, width: (1.0/3.0), height: 1)),
                LayoutArea(title: "Third", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: (2.0 / 3.0), y: 0, width: (1.0/3.0), height: 1))
            ])
        )
        
        schemes.append(
            LayoutScheme(title: "Four sides", areas: [
                LayoutArea(title: "Top-Left", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 0.5)),
                LayoutArea(title: "Top-Right", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5)),
                LayoutArea(title: "Bottom-Left", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0.5, width: 0.5, height: 0.5)),
                LayoutArea(title: "Bottom-Right", activeKey: .four, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
            ])
        )
        
        return schemes
    }
    
}
