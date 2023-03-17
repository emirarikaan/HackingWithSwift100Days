//
//  ViewController.swift
//  Project19
//
//  Created by Emir Arıkan on 23.02.2023.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert,.badge,.sound]){granted,error in
            if granted{
                print("yay!")
            }
            else{
                print("doh")
            }
        }
        
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "Come on brooooooo"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        content.userInfo = ["customData":"fizzbuzz"]
        //bak
//        var dateComponent = DateComponents()
//        dateComponent.hour = 10
//        dateComponent.minute = 30
//       
//              let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more..",options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later...", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,remind], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String{
            print("Custom data received: \(customData)")
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                showAlert(title: "This is a default identifier", message: "Not special! Sorry :(")

            case "show":
                showAlert(title: "This is show more button!", message: "Here is the your notification information;\n\(customData)")
            case "remind":
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let secondContent = UNMutableNotificationContent()
                secondContent.title = "Reminder!"
                secondContent.body = "Remind me later..."
                secondContent.userInfo = response.notification.request.content.userInfo
                secondContent.categoryIdentifier = response.notification.request.content.categoryIdentifier
                secondContent.sound = UNNotificationSound.default
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: secondContent, trigger: trigger)
                center.add(request)


            default:
                break
            }
        }
        completionHandler()

    }
    func showAlert(title: String?, message: String?){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
        
        present(ac, animated: true)
    }
}

