//
//  ViewController.swift
//  Day16-18
//
//  Created by Emir Arıkan on 30.01.2023.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    let defaults = UserDefaults.standard
    var pictures = [String]()
    var picturesShowCount = [Int]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
            
        }
        pictures.sort()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        for picture in pictures {
            picturesShowCount.append(defaults.object(forKey: picture) as? Int ?? 0)
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
        let showingCount = defaults.object(forKey: pictures[indexPath.row]) as? Int ?? 0
        cell.detailLabel.text = String(showingCount)
        cell.textL.text = pictures[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
        defaults.set(picturesShowCount[indexPath.row] + 1, forKey: pictures[indexPath.row])
        picturesShowCount[indexPath.row] = picturesShowCount[indexPath.row] + 1
        self.tableView.reloadData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        let destinationVC = segue.destination as? DetailViewController
        destinationVC?.selectedImage = pictures[indeks!]
        
    }
    
}

