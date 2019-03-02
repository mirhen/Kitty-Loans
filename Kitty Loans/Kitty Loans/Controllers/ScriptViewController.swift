//
//  ScriptViewController.swift
//  Houndify Chat
//
//  Created by Miriam Haart on 3/3/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import Firebase
import SafariServices

protocol OptionsViewDelegate: class {
    func didTapResponseButton(_ response: String, on optionsView: OptionsView)
}
protocol DateOptionViewDelegate: class {
    func didSendResponse(_ responseDate: Date?, on dateOptionView: DateOptionView)
}

enum Script {
    case onBoard
    case journal
    case breastRisk
    case learnMore
    case selfExam
    case monthlyReminder
    case loanAgreement
}

class ScriptViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optionsView: OptionsView!
    @IBOutlet weak var dateOptionView: DateOptionView!
    
    
    //MARK: Properties
    var messages = [Message]()
    var username: String = "Miriam"
    var isOnboard = false
    var script: Script = .loanAgreement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        if let user = Firebase.Auth.auth().currentUser {
//            username = user.displayName!.components(separatedBy: " ")[0]
//            print(username)
//        }
        dateOptionView.isHidden = true
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        optionsView.delegate = self
        dateOptionView.delegate = self
        
        if isOnboard {
            script = .onBoard
            optionsView.setOptions(options: ["hello"])
            messages.append(Message("Hi \(username), I'm Norma!"))
        }
        tableView.reloadData()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
            messages = []
            optionsView.setOptions(options: ["Yes!", "Definitely", "Another time"])
            messages.append(Message("Hi \(username)! I see you want to begin a loan"))

        tableView.reloadData()
    }
    
    func showPromptFor(response: String) {
        
        changeScriptTo(response: response)

        switch self.script {
        
        case .loanAgreement:
            loanAgreementScript(response: response)
            
        default:
            break
        }
        
        
        self.tableView.reloadData()
        scrollToBottom(animated: true)
        
    }
    
    
    func openBreastCancerRiskAssesmentTool() {
        let svc = SFSafariViewController(url: URL(string: "https://www.cancer.gov/bcrisktool/")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let index = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: index, at: .top, animated: animated)
        }
    }
    func moveToBottom() {
        
        if messages.count > 0  {
            
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

extension ScriptViewController: OptionsViewDelegate {
    func didTapResponseButton(_ response: String, on optionsView: OptionsView) {
        messages.append(Message(response, from: .user))
        tableView.reloadData()
        showPromptFor(response: response)
    }
}
extension ScriptViewController: DateOptionViewDelegate {
    func didSendResponse(_ responseDate: Date?, on dateOptionView: DateOptionView) {
        if let date = responseDate {
        
            messages.append(Message("It's \(date.toPrettyString())", from: .user))
            tableView.reloadData()
            showPromptFor(response: "date selected")
        } else {
            messages.append(Message("this does not apply to me", from: .user))
            tableView.reloadData()
            showPromptFor(response: "this does not apply to me")
        }
        dateOptionView.isHidden = true
        
        
    }
}
extension ScriptViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
extension ScriptViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        let message = messages[indexPath.row]
        
        cell.configCell(message: message)
        
        return cell
    }
}
