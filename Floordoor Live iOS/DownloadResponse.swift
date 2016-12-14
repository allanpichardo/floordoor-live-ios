//
//  DownloadResponse.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import Foundation

class DownloadResponse {
    
    var isSuccess: Bool! = false
    
    init(){
        
    }
    
    init(response: String){
        let json = JSON(stringLiteral: response)
        isSuccess = json["execution"].bool
    }
}
