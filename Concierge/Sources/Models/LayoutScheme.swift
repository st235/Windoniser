import Foundation

struct LayoutScheme {
    
    let title: String
    let iconName: String
    let areas: [LayoutArea]
    let separators: [Vector2]
    
    init(title: String, iconName: String, areas: [LayoutArea], separators: [Vector2]) {
        self.title = title
        self.iconName = iconName
        self.areas = areas
        self.separators = separators
    }
    
}
