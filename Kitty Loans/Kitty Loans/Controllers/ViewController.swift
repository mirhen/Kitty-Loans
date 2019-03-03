//
//  ViewController.swift
//  Kitty Loans
//
//  Created by Miriam Haart on 3/2/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func backButtonPressed(_ sender: Any) {
        let initialViewController = UIStoryboard.initialViewController(for: .home)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

