import Foundation

struct LayoutScheme {
    
    let title: String
    let areas: [LayoutArea]
    
    init(title: String, areas: [LayoutArea]) {
        self.title = title
        self.areas = areas
    }
    
}
