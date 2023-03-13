//
//  ViewController.swift
//  Project5
//
//  Created by Emir Arıkan on 3.02.2023.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetGame))
        
        if allWords.isEmpty {
            allWords = ["Emir"]
        }
        
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    func startGame() {
        if let current = defaults.object(forKey: "usedWords") as? String{
            title = current
        }
        else{
            title = allWords.randomElement()
            defaults.set(title, forKey: "currentWord")
        }
        if let savedUsedWords = defaults.object(forKey: "usedWords") as? [String]{
            usedWords = savedUsedWords
        }
        tableView.reloadData()
    }
    @objc func resetGame(){
        let newWorld = allWords.randomElement()
        DispatchQueue.main.async {
            
            self.defaults.set(newWorld, forKey: "newWords")
            self.defaults.set([String](),forKey: "usedWords")
            self.startGame()
        }
        
    }
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle : String
        let errorMessage : String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(answer, at: 0)
                    DispatchQueue.main.async {
                        self.defaults.set(self.usedWords, forKey: "usedWords")
                    }
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                }else{
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            }else{
                errorTitle = "Already Used"
                errorMessage = "Be more original"
            }
        }else{
            guard let title = title else{return}
            errorTitle = "word not possible"
            errorMessage = "You can't spell that word from \(title.lowercased())."
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated: true)
        
        
    }
    func isPossible (word: String) -> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word{
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    
    func isOriginal (word : String) -> Bool{
        if word.lowercased() == title?.lowercased(){
            return false
        }
        return !usedWords.contains(word)
    }
    
    func isReal(word : String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        if range.length < 3{
            return false
        }
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

