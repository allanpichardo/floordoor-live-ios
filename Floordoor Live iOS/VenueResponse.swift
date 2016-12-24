//
//  VenueResponse.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import Foundation

class VenueResponse {
    
    var isSuccess: Bool = false
    var id: Int?
    var name: String?
    var coordinates: Coordinates?
    var imageUrl: String?
    
    init(){}
    
    init(json: JSON){
        
        let content = json["content"]
        isSuccess = json["execution"].boolValue
        
        id = content["id"].intValue
        name = content["name"].stringValue
        
        let latitude = content["latitude"].doubleValue
        let longitude = content["longitude"].doubleValue
        coordinates = Coordinates(latitude: latitude, longitude: longitude)
        
        imageUrl = content["image_url"].stringValue
        
    }
}
