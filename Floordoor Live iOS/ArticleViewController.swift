//
//  ArticleViewController.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/22/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    public var article: FeedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadArticlePage()
    }
    
    private func loadArticlePage(){
        
        guard let article = article,
                let body = article.feedContent,
                let url = article.feedLink else {
                    
            return
                    
        }
        webView.loadHTMLString(body, baseURL: URL(string: url))
        self.navigationItem.title = article.feedTitle
        
        let bodyStyle = "document.getElementsByTagName('body')[0].style.textAlign = 'center';";
        let articleStyle = "document.getElementsByTagName('article')[0].style.margin = 'auto';";
        webView.stringByEvaluatingJavaScript(from: bodyStyle)
        webView.stringByEvaluatingJavaScript(from: articleStyle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
