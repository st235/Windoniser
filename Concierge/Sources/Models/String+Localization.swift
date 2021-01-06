import Foundation

extension String {
    
    var localized: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
    
}
