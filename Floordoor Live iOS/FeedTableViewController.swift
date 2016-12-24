//
//  FeedTableTableViewController.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/20/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    public weak var parentViewController: FeedTableViewController?
    public var article: FeedItem?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
    }
    
    @IBAction func onShareClicked(_ sender: UIButton) {
        if let feedItem = article {
            shareArticle(article: feedItem)
        }
    }
    
    private func shareArticle(article: FeedItem){
        var shareItems = [Any]()
        
        if let link = article.feedLink {
            shareItems.append(link)
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        if let parent = parentViewController {
            parent.present(activityViewController, animated: true, completion: { 
                
            })
        }
    }
}

class FeedTableViewController: UITableViewController, FeedParserDelegate {
    
    static let IDENTIFIER_CELL = "BlogItem"
    
    var activityIndicator = UIActivityIndicatorView()
    var articles: [FeedItem]?
    var feedParser: FeedParser?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        articles = []

        initActivityIndicator()
        loadArticles()
    }
    
    private func initActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
    }
    
    private func loadArticles(){
        toggleLoading(isLoading: true)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
            self.feedParser = FeedParser(feedURL: Api.URL_RSS)
            self.feedParser?.feedType = FeedType.RSS2
            self.feedParser?.delegate = self
            self.feedParser?.parse()
        })
    }
    
    private func toggleLoading(isLoading: Bool?){
        
        if let isLoading = isLoading {
            if isLoading {
                showIndicator()
            }else{
                hideIndicator()
            }
        }else{
            hideIndicator()
        }
    }
    
    private func showIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.backgroundColor = UIColor.white
        activityIndicator.startAnimating()
        self.tableView.isHidden = false
    }
    
    private func hideIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        self.tableView.isHidden = false
    }
    
    // MARK: - FeedParserDelegate methods
    
    func feedParser(_ parser: FeedParser, didParseChannel channel: FeedChannel) {
        // Here you could react to the FeedParser identifying a feed channel.
        DispatchQueue.main.async(execute: { () -> Void in
            //something
        })
    }
    
    func feedParser(_ parser: FeedParser, didParseItem item: FeedItem) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.articles?.append(item)
        })
    }
    
    func feedParser(_ parser: FeedParser, successfullyParsedURL url: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            if ((self.articles?.count)! > 0) {
                self.toggleLoading(isLoading: false)
                self.tableView.reloadData()
            } else {
                self.toggleLoading(isLoading: false)
            }
        })
    }
    
    func feedParser(_ parser: FeedParser, parsingFailedReason reason: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.articles = []
            self.toggleLoading(isLoading: false)
        })
    }
    
    func feedParserParsingAborted(_ parser: FeedParser) {
        self.articles = []
        toggleLoading(isLoading: false)
    }
    
    // MARK: - Network methods
    func loadImageSynchronouslyFromURLString(_ urlString: String) -> UIImage? {
        if let url = URL(string: urlString) {
            let request = NSMutableURLRequest(url: url)
            request.timeoutInterval = 30.0
            var response: URLResponse?
            let error: NSErrorPointer? = nil
            var data: Data?
            do {
                data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            } catch let error1 as NSError {
                error??.pointee = error1
                data = nil
            }
            if (data != nil) {
                return UIImage(data: data!)
            }
        }
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewController.IDENTIFIER_CELL, for: indexPath) as! FeedTableViewCell

        // Configure the cell...
        guard let article = articles?[indexPath.row] else {
            return cell
        }
        
        cell.article = article
        cell.parentViewController = self
        
        if let htmlDescription = article.feedContentSnippet?.data(using: String.Encoding.unicode){
            do {
                let attributedText = try NSAttributedString(data: htmlDescription, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                cell.descriptionText.text = attributedText.string
            } catch let e as NSError {
                print(e.description)
                cell.descriptionText.text = article.feedContentSnippet
            }
        }else{
            cell.descriptionText.text = article.feedContentSnippet
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        cell.dateText.text = dateFormatter.string(from: article.feedPubDate!)
        
        cell.titleText.text = article.feedTitle
        
        if let imageUrl = article.featuredImage {
            DispatchQueue.main.async {
                cell.backgroundImage.image = self.loadImageSynchronouslyFromURLString(imageUrl)
            }
        }else{
            cell.backgroundImage.image = nil
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if let feedItem = articles?[(indexPath as NSIndexPath).row] {
                let destination = segue.destination as! ArticleViewController
                destination.article = feedItem
            }
        }
    }
    

}
