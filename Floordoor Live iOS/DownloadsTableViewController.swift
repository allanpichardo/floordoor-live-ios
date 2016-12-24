//
//  DownloadsTableViewController.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/23/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "DownloadCell"
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var albumId: Int?
    
    
    public func initWith(album: AlbumResponse){
        albumId = album.albumId!
        artistLabel.text = album.artist!
        titleLabel.text = album.title!
        
        DispatchQueue.main.async {
            let image = Api.loadImageSynchronouslyFromURLString(album.imageUrl!)
            self.albumImage.image = image
        }
    }
}

class DownloadsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
    public var venue: VenueResponse?
    private var albums = [AlbumResponse]()
    private var selections = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let venue = venue {
            navigationItem.title = venue.name
            retrieveAlbums(venue: venue)
        } else {
            notifyNoDownloadsAvailable()
        }
    }
    
    private func retrieveAlbums(venue: VenueResponse){
        
        Api.getPerformances(venue.id!) { (performance) in
            if performance.isSuccess! {
                if let albumIds = performance.albumIds {
                    self.retrieveAlbumMetadata(albumIds: albumIds)
                }
            } else {
                self.notifyNoDownloadsAvailable()
            }
        }
    }
    
    private func retrieveAlbumMetadata(albumIds: [Int]){
        for id in albumIds {
            Api.getAlbumInfo(id, callback: { (album) in
                let isAlreadyAdded = self.albums.contains(where: { (element) -> Bool in
                    return album.albumId! == element.albumId!
                })
                if !isAlreadyAdded {
                    self.albums.append(album)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    private func notifyNoDownloadsAvailable(){
        let alert = UIAlertController(title: "No Downloads for this Show", message: "Sorry, but there are no exclusive downloads for this venue at this time. But this will change, so check back soon.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateSelections() {
        continueButton.isEnabled = selections.count > 0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableViewCell.IDENTIFIER, for: indexPath) as! DownloadTableViewCell

        let album = albums[indexPath.row]
        cell.initWith(album: album)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell  = tableView.cellForRow(at: indexPath) as! DownloadTableViewCell
        selections.insert(selectedCell.albumId!)
        
        validateSelections()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell  = tableView.cellForRow(at: indexPath) as! DownloadTableViewCell
        selections.remove(selectedCell.albumId!)
        
        validateSelections()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let emailController = segue.destination as! EmailViewController
        emailController.selections = selections
    }

}
