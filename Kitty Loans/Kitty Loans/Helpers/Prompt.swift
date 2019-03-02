//
//  Prompt.swift
//  Journal
//
//  Created by Miriam Haart on 3/4/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

extension ScriptViewController {
    
//   else if response == "Ok" || response ==  "I did it!" {
//            self.performSegue(withIdentifier: "exitToEntry", sender: self)
//        }
//    }
    
    
    func changeScriptTo(response: String) {
        if response == "1" {
            self.script = .loanAgreement
        } else {
            self.script = .loanAgreement
        }
    }
    
    
    func loanAgreementScript(response: String) {
        if response == "Yes!" || response == "Definitely" || response == "Another time" {
            messages.append(Message("Great, we’ll go over three simple questions."))
            messages.append(Message("First, how much should the loan be for?"))
            optionsView.setOptions(options: ["$25", "$50", "$500"])
        } else if response == "$25" || response == "$50" || response == "$500" {
            
            messages.append(Message("Great, how long is the loan for?"))
            loanAgreementScript(response: "3")
            
        } else if response == "3" {
            optionsView.setOptions(options: ["Next", "yo", "do", "bro"])
            dateOptionView.isHidden = false
            
            dateOptionView.datePicker.minimumDate = Date()
            dateOptionView.datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
            messages.append(Message("Great, about how long is the loan for?"))
            
        } else if response == "Next" {
            
            optionsView.setOptions(options: ["Awesome!", "Yay! I have a cat, thanks!"])
            messages.append(Message("You're all set, you officially adopted a cat!"))
            messages.append(Message("Its name is Snowball!"))
            messages.append(Message("Let's start raising the cat, ttyl \(username)"))
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        }
    }
}
