import WebKit
import Foundation

class SettingsLicensesController: BundleViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        let url = loadUrl()
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func loadUrl() -> URL {
        guard let url = bundle as? URL else {
            fatalError("Url should be passed")
        }
        return url
    }
    
}
