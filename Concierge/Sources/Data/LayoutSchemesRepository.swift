import Foundation

class LayoutSchemesRepository {
    
    func providePreferredScheme() -> LayoutScheme {
        return LayoutScheme(title: "Custom", iconName: "Custom", areas: [
            LayoutArea(title: "Left", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
            LayoutArea(title: "Right-Top", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)),
            LayoutArea(title: "Right-Bottom", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
        ], separators: [
            Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),
            Vector2(x: NSPoint(x: 0.5, y: 0.5), y: NSPoint(x: 1, y: 0.5))
        ])
    }
    
    func provideDefaultSchemes() -> [LayoutScheme] {
        var schemes = [LayoutScheme]()
        
        schemes.append(
            LayoutScheme(title: "Fullscreen", iconName: "Fullscreen", areas: [
                LayoutArea(title: "Main", activeKey: .f, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 1, height: 1))
            ], separators: [])
        )

        schemes.append(
            LayoutScheme(title: "Two vertical sides", iconName: "TwoVertical", areas: [
                LayoutArea(title: "Left", activeKey: .l, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
                LayoutArea(title: "Right", activeKey: .r, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
            ], separators: [
                Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1))
            ])
        )

        schemes.append(
            LayoutScheme(title: "Two horizontal sides", iconName: "TwoHorizontal", areas: [
                LayoutArea(title: "Top", activeKey: .t, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 1, height: 0.5)),
                LayoutArea(title: "Bottom", activeKey: .b, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0.5, width: 1, height: 0.5))
            ], separators: [
                Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))
            ])
        )

        schemes.append(
            LayoutScheme(title: "Three sides", iconName: "ThreeHorizontal", areas: [
                LayoutArea(title: "First", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: (1.0/3.0), height: 1)),
                LayoutArea(title: "Second", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 1.0 / 3.0, y: 0, width: (1.0/3.0), height: 1)),
                LayoutArea(title: "Third", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: (2.0 / 3.0), y: 0, width: (1.0/3.0), height: 1))
            ], separators: [
                Vector2(x: NSPoint(x: 1.0/3.0, y: 0), y: NSPoint(x: 1.0/3.0, y: 1)),
                Vector2(x: NSPoint(x: 2.0/3.0, y: 0), y: NSPoint(x: 2.0/3.0, y: 1))
            ])
        )

        schemes.append(
            LayoutScheme(title: "Four sides", iconName: "Quadro", areas: [
                LayoutArea(title: "Top-Left", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 0.5)),
                LayoutArea(title: "Top-Right", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5)),
                LayoutArea(title: "Bottom-Left", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0.5, width: 0.5, height: 0.5)),
                LayoutArea(title: "Bottom-Right", activeKey: .four, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
            ], separators: [
                Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),
                Vector2(x: NSPoint(x: 0, y: 0.5), y: NSPoint(x: 1, y: 0.5))
            ])
        )
        
        schemes.append(
            LayoutScheme(title: "Custom", iconName: "Custom", areas: [
                LayoutArea(title: "Left", activeKey: .one, modifiers: [.shift, .control], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
                LayoutArea(title: "Right-Top", activeKey: .two, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)),
                LayoutArea(title: "Right-Bottom", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
            ], separators: [
                Vector2(x: NSPoint(x: 0.5, y: 0), y: NSPoint(x: 0.5, y: 1)),
                Vector2(x: NSPoint(x: 0.5, y: 0.5), y: NSPoint(x: 1, y: 0.5))
            ])
        )
        
        return schemes
    }
    
}
