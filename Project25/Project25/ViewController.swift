//
//  ViewController.swift
//  Project25
//
//  Created by Emir Arıkan on 7.03.2023.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController {
    
    @IBOutlet weak var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        
    }
    
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Login unsuccessful!", message: "Do you wanna use password?", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Use password", style: .default, handler: self?.unlockWithPassword))
                        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = nil
        
    }
    func unlockWithPassword(_ action : UIAlertAction? = nil){
        let passwordAc = UIAlertController(title: "Enter Your password", message: nil, preferredStyle: .alert)
          passwordAc.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self ,weak passwordAc] _ in
            guard let field = passwordAc?.textFields?[0].text else { return }
                  self?.checkPassword(password: field)
              }

              passwordAc.addAction(submitAction)
              present(passwordAc, animated: true)
        }
    func checkPassword(password: String){
      let appPassword = KeychainWrapper.standard.string(forKey: "Password") ?? ""
      if password == appPassword{
          unlockSecretMessage()
      }else{
          let errorAc = UIAlertController(title: "Wrong password", message: nil, preferredStyle: .alert)
          errorAc.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: unlockWithPassword))
          errorAc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          present(errorAc, animated: true)
      }
    }
    }


