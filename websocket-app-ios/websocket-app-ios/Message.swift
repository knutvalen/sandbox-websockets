//
//  Message.swift
//  websocket-app-ios
//
//  Created by Knut Valen on 07/02/2018.
//  Copyright © 2018 Knut Valen. All rights reserved.
//

import UIKit

class Message {
    
    var description: String
    
    init?(description: String) {
        if description.isEmpty {
            return nil
        }
        
        self.description = description
    }
}
