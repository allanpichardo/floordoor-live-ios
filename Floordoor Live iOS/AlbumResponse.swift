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
    
    init(response: String){
        let json = JSON(stringLiteral: response)
        let content = json["content"]
        
        artist = content["artist"].string
        title = content["title"].string
        imageUrl = content["image_url"].string
        albumId = content["album_id"].int
        
        if let execution = json["execution"].bool,
            let title = title {
            isSuccess = execution && !title.isEmpty
        }else{
            isSuccess = false
        }
    }
    
    init(){
        
    }
}
