//
//  Storyboard+Utility.swift
//  Instagram
//
//  Created by Miriam Haart on 2/22/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum MGType: String {
        case main
        case login
        case journal
        case home
        case management
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: MGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
}
