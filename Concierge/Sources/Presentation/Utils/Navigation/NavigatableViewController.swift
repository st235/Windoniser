import Foundation

class NavigatableViewController: NSViewController {
    
    var navigationTitle: String {
        get {
            return className
        }
    }
    
    var bundle: Any?
    
}
