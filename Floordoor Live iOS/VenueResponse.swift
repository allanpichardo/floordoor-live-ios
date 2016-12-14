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
    
    init(response: String){
        let json = JSON(stringLiteral: response)
        let content = json["content"]
        
        id = content["id"].int
        name = content["name"].string
        
        if let latitude = content["latitude"].double,
           let longitude = content["longitude"].double {
            coordinates = Coordinates(latitude: latitude, longitude: longitude)
        }
        
        imageUrl = content["image_url"].string
        
    }
}
