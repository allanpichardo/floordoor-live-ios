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
            callback(VenueResponse(response: Api.RESPONSE_ERROR))
            return
        }
        
        let url = Api.URL_GET_VENUE + "\(latitude),\(longitude)"
        
        getRequest(url: url) { (result) in
            callback(VenueResponse(response: result))
        }
    }
    
    static func getRequest(url: String, callback: @escaping (_ response: String) -> Void) -> Void {
        Alamofire.request(url).responseString { response in
            if let result = response.result.value {
                callback(result)
            }else{
                callback(Api.RESPONSE_ERROR)
            }
        }
    }
    
    static func postRequest(url: String, parameters: Parameters, callback: @escaping (_ response: String) -> Void) -> Void {
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters).responseString { (response) in
            if let result = response.result.value {
                callback(result)
            }else{
                callback(Api.RESPONSE_ERROR)
            }
        }
    }
    
}
