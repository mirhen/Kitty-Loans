//
//  ScriptViewController.swift
//  Houndify Chat
//
//  Created by Miriam Haart on 3/3/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Speech
import SafariServices

protocol OptionsViewDelegate: class {
    func didTapResponseButton(_ response: String, on optionsView: OptionsView)
    func didTalk(_ voice: String)
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
    
    var lastButtonString = "$200"
    @IBOutlet weak var voiceButton: UIButton!
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
    @IBAction func voiceButtonPressed(_ sender: Any) {
        if isRecording == true {
            cancelRecording()
            isRecording = false
            voiceButton.backgroundColor = UIColor.gray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            voiceButton.backgroundColor = UIColor.red
        }
    }
    
    //MARK: Properties
    var messages = [Message]()
    var username: String = "Miriam"
    var isOnboard = false
    var script: Script = .loanAgreement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.requestSpeechAuthorization()
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
    func didTalk(_ voice: String) {
        
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



extension ScriptViewController: SFSpeechRecognizerDelegate {
    

    
    func cancelRecording() {
        audioEngine.stop()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
    
    //MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                print(bestString)
                self.optionsView.setLastButton(text: bestString)
                
            } else if let error = error {
                // self.sendAlert(message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.voiceButton.isEnabled = true
                case .denied:
                    self.voiceButton.isEnabled = false
                    print("User denied access to speech recognition")
                case .restricted:
                    self.voiceButton.isEnabled = false
                    print("Speech recognition restricted on this device")
                case .notDetermined:
                    self.voiceButton.isEnabled = false
                    print("Speech recognition not yet authorized")
                }
            }
        }
    }
    
    //MARK: - Alert
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
