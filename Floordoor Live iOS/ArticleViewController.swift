//
//  ArticleViewController.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/22/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var webView: WKWebView?
    
    public var article: FeedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        webView = WKWebView(frame: self.view.frame)
        webView?.navigationDelegate = self
        self.view.insertSubview(webView!, at: 0)
        loadArticlePage()
    }
    
    private func toggleActivityIndicator(isShowing: Bool) {
        activityIndicator.isHidden = !isShowing
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let textSize: Int = 300
        let textStyle = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'"
        let bodyStyle = "document.getElementsByTagName('article')[0].style.textAlign = 'center'";
        let articleStyle = "document.getElementsByTagName('article')[0].style.margin = '0 auto'";
        
        webView.evaluateJavaScript(bodyStyle) { (arg, error) in
            print(error.debugDescription)
        }
        webView.evaluateJavaScript(articleStyle) { (arg, error) in
            print(error.debugDescription)
        }
        webView.evaluateJavaScript(textStyle) { (arg, error) in
            print(error.debugDescription)
        }
        toggleActivityIndicator(isShowing: false)
    }
    
    private func loadArticlePage(){
        
        guard let article = article,
                let body = article.feedContent,
                let url = article.feedLink else {
                    
            return
                    
        }
        
        webView?.loadHTMLString(body, baseURL: URL(string: url))
        self.navigationItem.title = article.feedTitle
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
