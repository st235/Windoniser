import WebKit
import Foundation

class SettingsLicensesController: NavigatableViewController {
    
    struct Data {
        let title: String
        let url: URL
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override var navigationTitle: String {
        get {
            return loadTitle()
        }
    }
    
    override func viewDidLoad() {
        let url = loadUrl()
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func loadTitle() -> String {
        guard let data = bundle as? Data else {
            fatalError("Url should be passed")
        }
        return data.title
    }
    
    private func loadUrl() -> URL {
        guard let data = bundle as? Data else {
            fatalError("Url should be passed")
        }
        return data.url
    }
    
}
