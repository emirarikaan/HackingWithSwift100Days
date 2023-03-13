//
//  ViewController.swift
//  Project2
//
//  Created by Emir Arıkan on 1.02.2023.
//

import UIKit

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    let defaults = UserDefaults.standard
    var countries = [String]()
    var score : Int = 0
    var correct = 0
    var correctAnswer = 0
    var howMuchQuestion = 0
    var highScoreSetted = false
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["afghanistan", "belgium", "colombia", "estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onTab))
        registerNotification()

        
    }
    func registerNotification(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Everything is okay")
                self.setNotification()
            } else {
                print("oh no! :(")
            }
        }
    }
    func setNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Come back! We miss you."
        content.body = "Hey! You wanna a quick game! I know. Come!"
        content.categoryIdentifier = "reminder"
        content.userInfo = ["gamename": "flag game"]
        content.sound = UNNotificationSound.default

        let components = Calendar.current.dateComponents([.day], from: Date.now)
        var dateComponents = DateComponents()

        dateComponents.day = (components.day ?? 0) + 1
        dateComponents.hour = 20
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)

        print("Trigger Date: \(dateComponents)")

    }
        
    
    @objc func onTab(action: UIAlertAction! = nil){
        let message = """
           Currently score is \(score)
           Tour : \(howMuchQuestion)
           Wrong Answer : \((howMuchQuestion - correct) - 1)
           Correct Answer : \(correct)
           """
        
        let vc = UIAlertController(title: "Score", message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(vc,animated: true)
    }
    func askQuestion(action : UIAlertAction! = nil){
        self.button1.transform = .identity
        self.button2.transform = .identity
        self.button3.transform = .identity
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        title = countries[correctAnswer].uppercased()
        
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: {finished in
            var message:String
            if sender.tag == self.correctAnswer{
                message = "Correct"
                self.score+=1
            }
            else{
                message = "Wrong"
                self.score-=1
            }
            let messageText = "Your score is \(self.score)"
            let alertController = UIAlertController(title: message, message: messageText, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default,handler: self.askQuestion
                                                   ))
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
}

