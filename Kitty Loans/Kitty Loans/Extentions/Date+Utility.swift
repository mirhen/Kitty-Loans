//
//  Date+Utility.swift
//  Journal
//
//  Created by Miriam Haart on 3/2/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation


extension Date {
    
    func toPrettyString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let newDate = dateFormatter.string(from: self)
        
        return newDate
    }
}
