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
    
    init(response: String){
        let json = JSON(stringLiteral: response)
        
        guard let content = json["content"].array,
        let execution = json["execution"].bool else {
            isSuccess = false
            return
        }
        
        isSuccess = execution && content.count > 0
        albumIds = []
        performances = Array()
        
        for entry in content {
            if let id = entry["album_id"].int{
                performances?.append(Performance(albumId: id))
                albumIds?.append(id)
            }
        }
        
    }
    
}
