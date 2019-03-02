//
//  Message.swift
//  Houndify Chat
//
//  Created by Miriam Haart on 3/3/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

enum Sender {
    case user
    case norma
}

struct Message {
    var text = ""
    var sender: Sender = .norma
    
    init(_ text: String) {
        self.text = text
    }
    
    init(_ text: String, from: Sender) {
        self.text = text
        self.sender = from
    }
}
