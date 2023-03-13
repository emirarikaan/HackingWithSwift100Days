//
//  ViewController.swift
//  Project7
//
//  Created by Emir Arıkan on 3.02.2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var mainPetitions = [Petition]()
    var dontChangePetitions = [Petition]()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showInformation))
        let leftItems = [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchFilter)), UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearFilter))]
                
        navigationItem.leftBarButtonItems = leftItems
        let urlString: String
           
           if navigationController?.tabBarItem.tag == 0 {
               urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
           } else {
               urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
           }

           if let url = URL(string: urlString) {
               if let data = try? Data(contentsOf: url) {
                   parse(json: data)
                   mainPetitions = petitions
                   dontChangePetitions = petitions
                   return
               }
           }

           showError()
       }
    @objc func clearFilter(){
        petitions = dontChangePetitions
        tableView.reloadData()
    }
    @objc func searchFilter(){
            let sac = UIAlertController(title:"Search any word", message: "Enter your keyword",preferredStyle: .alert)
            sac.addTextField()
            
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
               [weak self, weak sac] _ in
               guard let answer = sac?.textFields?[0].text else { return }
               self?.submit(answer)
           }
           sac.addAction(submitAction)
           present(sac, animated: true, completion: nil)
       }
    @objc private func submit(_ answer: String) {
        mainPetitions.removeAll()
                for petition in petitions {
                    if petition.title.contains(answer) {
                        mainPetitions.append(petition)
                    }
                }
        if !self.mainPetitions.isEmpty{
            self.petitions = self.mainPetitions
        }
                tableView.reloadData()
        }
        
    @objc func showInformation(){
        let iac = UIAlertController(title: "Information", message: "This information got by White House API", preferredStyle: .alert)
        iac.addAction(UIAlertAction(title: "OK", style: .default))

        present(iac,animated: true)
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPettions = try? decoder.decode(Petitions.self, from: json){
            self.petitions = jsonPettions.results
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

