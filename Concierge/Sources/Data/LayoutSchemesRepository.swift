import Foundation

class LayoutSchemesRepository {
    
    func providePreferredScheme() -> LayoutScheme {
        return LayoutScheme(areas: [
            LayoutArea(title: "Left", activeKey: .one, modifiers: [.shift, .option], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
            LayoutArea(title: "Right-Top", activeKey: .two, modifiers: [.shift, .option], rect: NSRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)),
            LayoutArea(title: "Right-Bottom", activeKey: .three, modifiers: [.shift, .control], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 0.5))
            
//            LayoutArea(title: "Left", activeKey: .l, modifiers: [.shift, .command], rect: NSRect(x: 0, y: 0, width: 0.5, height: 1)),
//            LayoutArea(title: "Right", activeKey: .r, modifiers: [.shift, .command], rect: NSRect(x: 0.5, y: 0, width: 0.5, height: 1))
        ])
    }
    
}
