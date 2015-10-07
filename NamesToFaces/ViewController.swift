//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Andrew  Nguyen on 10/2/15.
//  Copyright © 2015 Andrew Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var collectionView: UICollectionView!

    var people = [Person]()
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
        if let savedPeople = defaults.objectForKey("people") as? NSData {
            people = NSKeyedUnarchiver.unarchiveObjectWithData(savedPeople) as! [Person]
        }

    }

    func addNewPerson() {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func save() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(people)
        defaults.setObject(savedData, forKey: "people")
    }

    // MARK: - CollectionView DataSource

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! PersonCell

        let person = people[indexPath.row]

        cell.name.text = person.name

        let path = getDocumentsDirectory().stringByAppendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path)
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 03).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let ac = UIAlertController(title: "Would you like to rename or delete person?", message: nil, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .Default) { [unowned self] _ in
            let person = self.people[indexPath.row]

            let ac2 = UIAlertController(title: "Rename person", message: nil, preferredStyle: .Alert)
            ac2.addTextFieldWithConfigurationHandler(nil)

            ac2.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            ac2.addAction(UIAlertAction(title: "OK", style: .Default) { [unowned self, ac2] _ in
                let newName = ac2.textFields![0]
                person.name = newName.text!
                self.collectionView.reloadData()
                self.save()
                })

            self.presentViewController(ac2, animated: true, completion: nil)
        })

        ac.addAction(UIAlertAction(title: "Delete", style: .Destructive) { [unowned self] _ in
            self.people.removeAtIndex(indexPath.row)
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        presentViewController(ac, animated: true, completion: nil)

    }

    // MARK: - ImagePicker Delegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage

        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        let imageName = NSUUID().UUIDString
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)

        if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
            jpegData.writeToFile(imagePath, atomically: true)
        }

        let person = Person(name: "Unkown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
