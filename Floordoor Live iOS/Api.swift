//
//  Api.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import Foundation
import Alamofire

class Api {
    static let URL_RSS: String = "http://www.floordoorrecords.com/feed/"
    static let URL_GET_VENUE: String = "https://download.floordoorrecords.com/api/venue/"
    static let URL_GET_PERFORMANCES: String = "https://download.floordoorrecords.com/api/performances/"
    static let URL_GET_ALBUM: String = "https://download.floordoorrecords.com/api/album/"
    static let URL_POST_DOWNLOAD: String = "https://download.floordoorrecords.com/api/album"
    
    static let RESPONSE_ERROR = "{\"execution\":false}"
    
    static func getVenue(_ coordinates: Coordinates, callback: @escaping (_ response: VenueResponse) -> Void) -> Void {
        guard let latitude = coordinates.latitude, let longitude = coordinates.longitude else {
            callback(VenueResponse(json: JSON(stringLiteral: Api.RESPONSE_ERROR)))
            return
        }
        
        let url = Api.URL_GET_VENUE + "\(latitude),\(longitude)"
        
        getRequest(url: url) { (result) in
            callback(VenueResponse(json: result))
        }
    }
    
    static func getPerformances(_ venueId: Int, callback: @escaping (_ response: PerformanceResponse) -> Void) -> Void {
        
        let url = Api.URL_GET_PERFORMANCES + "\(venueId)"
        
        getRequest(url: url) { (result) in
            callback(PerformanceResponse(json: result))
        }
    }
    
    static func getAlbumInfo(_ albumId: Int, callback: @escaping (_ response: AlbumResponse) -> Void) -> Void {
        
        let url = Api.URL_GET_ALBUM + "\(albumId)"
        getRequest(url: url, callback: { (response) in
            let albumResponse = AlbumResponse(json: response)
            callback(albumResponse)
        })
    }
    
    static func requestDownloads(_ albumIds: [Int], email: String, callback: @escaping (_ response: DownloadResponse) -> Void) -> Void {
        
        let url = Api.URL_POST_DOWNLOAD
        
        guard let json = JSON(albumIds).rawString(options: [.castNilToNSNull: true]) else {
            callback(DownloadResponse(json: JSON(stringLiteral: Api.RESPONSE_ERROR)))
            return
        }
        
        var parameters = Parameters()
        parameters.updateValue(email, forKey: "email")
        parameters.updateValue(json, forKey: "json")
        
        postRequest(url: url, parameters: parameters) { (response) in
            let downloadResponse = DownloadResponse(json: response)
            callback(downloadResponse)
        }
    }
    
    static func getRequest(url: String, callback: @escaping (_ response: JSON) -> Void) -> Void {
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                callback(JSON(json))
            }else{
                callback(JSON(stringLiteral: Api.RESPONSE_ERROR))
            }
        }
    }
    
    static func postRequest(url: String, parameters: Parameters, callback: @escaping (_ response: JSON) -> Void) -> Void {
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON(json))
            }else{
                callback(JSON(stringLiteral: Api.RESPONSE_ERROR))
            }
        }
    }

    static func loadImageSynchronouslyFromURLString(_ urlString: String) -> UIImage? {
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
    
}
