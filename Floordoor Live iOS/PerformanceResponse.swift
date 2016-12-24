//
//  PerformanceResponse.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import Foundation

class PerformanceResponse{
    
    struct Performance {
        var albumId: Int
    }
    
    var isSuccess: Bool! = false
    var albumIds: [Int]?
    var performances: Array<Performance>?
    
    init(){}
    
    init(json: JSON){
        
        let content = json["content"].arrayValue
        let execution = json["execution"].boolValue
        
        isSuccess = execution && content.count > 0
        albumIds = []
        performances = Array()
        
        for entry in content {
            let id = entry["album_id"].intValue
            performances?.append(Performance(albumId: id))
            albumIds?.append(id)
        }
        
    }
    
}
