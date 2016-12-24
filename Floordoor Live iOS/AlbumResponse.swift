//
//  Album.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import Foundation

class AlbumResponse {
    var artist: String?
    var title: String?
    var imageUrl: String?
    var albumId: Int?
    var isSuccess: Bool! = false
    
    init(json: JSON){
        
        let content = json["content"]
        
        artist = content["artist"].stringValue
        title = content["title"].stringValue
        imageUrl = content["image_url"].stringValue
        albumId = content["album_id"].intValue
        
        let execution = json["execution"].boolValue

        isSuccess = execution && !title!.isEmpty

    }
    
    init(){
        
    }
}
