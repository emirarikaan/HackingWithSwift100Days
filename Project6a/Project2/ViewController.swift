//
//  ViewController.swift
//  Project2
//
//  Created by Emir Arıkan on 1.02.2023.
//

import UIKit

class ViewController: UIViewController {
    var countries = [String]()
    var score : Int = 0
    var correctAnswer:Int = 0
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["afghanistan", "belgium", "colombia", "estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

//        button1.layer.borderWidth = 1
//        button2.layer.borderWidth = 1
//         button3.layer.borderWidth = 1
        askQuestion()

    }

    func askQuestion(action : UIAlertAction! = nil){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        title = countries[correctAnswer].uppercased()
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        var message:String
        if sender.tag == correctAnswer{
            message = "Correct"
            score+=1
        }
        else{
            message = "Wrong"
            score-=1
        }
        let messageText = "Your score is \(score)"
        let alertController = UIAlertController(title: message, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default,handler: askQuestion
        ))
        present(alertController, animated: true, completion: nil)
    }
}

