import Foundation
import Accessibility

class AccessibilityPermissionsManager {
    
    func isPermissionGranted() -> Bool {
        return AXIsProcessTrusted()
    }
    
    func requestPermission() {
        let promptFlag = kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString
        let options = NSDictionary(dictionary: [promptFlag: true])
        AXIsProcessTrustedWithOptions(options)
    }
    
}
