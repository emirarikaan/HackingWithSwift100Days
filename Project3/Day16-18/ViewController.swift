//
//  ViewController.swift
//  Day16-18
//
//  Created by Emir Arıkan on 30.01.2023.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var pictures = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for picture in items{
            if picture.hasPrefix("nssl"){
                pictures.append(picture)}
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return pictures.count
        }

         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resim", for: indexPath) as! TableViewCell
            cell.textL.text = pictures[indexPath.row]
            
            return cell
        }

        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        let destinationVC = segue.destination as? DetailViewController
        destinationVC?.selectedImage = pictures[indeks!]
        
    }
    

}

