//
//  OptionsView.swift
//  Houndify Chat
//
//  Created by Miriam Haart on 3/3/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

class OptionsView: UIView {
    
    @IBOutlet weak var intentLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    
    // MARK: - Properties
    weak var delegate: OptionsViewDelegate?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let userResponse = sender.currentTitle ?? ""
        delegate?.didTapResponseButton(userResponse, on: self)
        
    }
    
    override func draw(_ rect: CGRect) {
        for button in stackView.arrangedSubviews {
            button.layer.cornerRadius = 20
        }
    }
    
    func setOptions(options: [String]) {
        for i in 0...3 {
            let button = stackView.arrangedSubviews[i] as? UIButton
            let isIndexValid = options.indices.contains(i)
            if isIndexValid {
                button?.setTitle(options[i], for: .normal)
                button?.isHidden = false
            } else {
                button?.isHidden = true
            }
        }
    }
    
    func setLastButton(text: String) {
        buttonThree.setTitle(text, for: .normal)
    }
    
    
}
