import UIKit

class WebViewController: UIViewController {

    let webView: UIWebView = {
        let wv = UIWebView(frame: UIScreen.mainScreen().bounds)
        wv.scalesPageToFit = true
        return wv
        }()

    override func loadView() {
        self.view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
