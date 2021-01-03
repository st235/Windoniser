import Foundation
import AppKit

class MainViewController: NSViewController {
    
    @IBOutlet weak var layoutPreviewView: LayoutPreviewView!
    
    override func viewDidLoad() {
        layoutPreviewView.setBackgroundColor(backgroundColor: .white)
        let accessbilityController = WindowController()
        
        for window in accessbilityController.requestAllWindows() {
            if let window = window as? Window {
                print("pid: \(window.pid)\ntitle: \(window.title())\nposition: \(window.position())\nsize: \(window.size())")
            }
        }
        
        quaterLayout()
    }
    
    private func quaterLayout() {
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0, y: 0, width: 0.5, height: 0.5))
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0, y: 0.5, width: 0.5, height: 0.5))
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0.5, y: 0, width: 0.5, height: 0.5))
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0.5, y: 0.5, width: 0.5, height: 0.5))
    }
    
    private func tripleLayout() {
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0, y: 0, width: 0.33, height: 1))
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0.33, y: 0, width: 0.33, height: 1))
        layoutPreviewView.addLayoutPreview(layoutPreview: LayoutPreviewView.LayoutPreview(x: 0.67, y: 0, width: 0.33, height: 1))
    }
    
    static func newController() -> MainViewController {
      let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
      let identifier = NSStoryboard.SceneIdentifier("MainViewController")
      guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MainViewController else {
        fatalError("Why cant i find MainViewController? - Check Main.storyboard")
      }
      return viewcontroller
    }
    
}
