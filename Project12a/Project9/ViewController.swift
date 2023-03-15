//
//  ViewController.swift
//  Project9
//
//  Created by Emir Arıkan on 10.02.2023.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    var people = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        let defaults = UserDefaults.standard
        if let savePeople = defaults.object(forKey: "people") as? Data{
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savePeople) as? [Person]{
                people = decodedPeople
            }
        }

        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()

        dismiss(animated: true)
    }
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        picker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            picker.sourceType = .camera
//        }
        picker.allowsEditing = true
        present(picker,animated: true)
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            fatalError("The cell unable")
        }

        let person = people[indexPath.item]
        cell.name.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let fac  = UIAlertController(title: "What is your choice", message: nil, preferredStyle: .alert)
        fac.addAction(UIAlertAction(title: "Rename", style: .default){ [weak self] _ in
            let sac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            sac.addTextField()

            sac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            sac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak sac] _ in
                guard let newName = sac?.textFields?[0].text else { return }
                person.name = newName
                self?.save()

                self?.collectionView.reloadData()
            })
            self!.present(sac,animated: true)
        })

        fac.addAction(UIAlertAction(title: "Delete", style: .default){ [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })

        present(fac, animated: true)
    }
    func save(){
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}
