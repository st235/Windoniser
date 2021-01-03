import Foundation
import AppKit

class LeftSideMenuViewController: NSViewController {
    
    @IBOutlet weak var layoutPreviewView: LayoutPreviewView!
    
    override func viewDidLoad() {
        layoutPreviewView.setBackgroundColor(backgroundColor: .white)
    }
    
    static func create() -> LeftSideMenuViewController {
      let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
      let identifier = NSStoryboard.SceneIdentifier("LeftSideMenuViewController")
      guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LeftSideMenuViewController else {
        fatalError("Check storyboard. Probably, id of view controller does not match with id below")
      }
      return viewcontroller
    }
}
