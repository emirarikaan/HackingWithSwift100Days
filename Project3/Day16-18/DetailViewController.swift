//
//  DetailViewController.swift
//  Day16-18
//
//  Created by Emir Arıkan on 31.01.2023.
//

import UIKit
import Social
class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage:String?
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        super.viewDidLoad()
        if let f = selectedImage{
            imageView.image = UIImage(named: f)
        }
        // Do any additional setup after loading the view.
    }
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.3) else{
            print("error")
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = true
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
