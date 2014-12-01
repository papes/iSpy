import UIKit
import WebKit

class WebView: UIViewController {
    
    @IBOutlet var containerView : UIView! = nil
    var webView: WKWebView?
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    @IBAction func goBackHome(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string:"http://ispyj7t7.elasticbeanstalk.com/index.jsp")
        var req = NSURLRequest(URL:url!)
        self.view.addSubview(navBar)
        webView?.clipsToBounds = false
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}