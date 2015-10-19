//
//  Message.swift
//  SyncanoChat
//
//  Created by Mariusz Wisniewski on 10/19/15.
//  Copyright © 2015 Mariusz Wisniewski. All rights reserved.
//

import UIKit
import syncano_ios

class Message: SCDataObject {
    var text = ""
    var senderId = ""
    var attachment : SCFile?
    
    override class func extendedPropertiesMapping() -> [NSObject: AnyObject] {
        return [
            "senderId":"senderid"
        ]
    }
}