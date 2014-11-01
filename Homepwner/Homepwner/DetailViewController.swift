//
//  DetailViewController.swift
//  Homepwner
//
//  Created by John Regner on 10/5/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

//define bind operator
infix operator >>> { associativity left precedence 150 }
func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var item: BNRItem! {  //will be loaded when this view is pushed onto the view controller
        didSet{
            navigationItem.title = self.item.itemName
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        nameField.text = item.itemName
        serialField.text = item.serialNumber
        valueField.text = "\(item.valueInDollars)"
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateLabel.text = formatter.stringFromDate(item.dateCreated)
        let imageToDisplay = item.imageKey >>> BNRImageStore.sharedStore.imageForKey
        imageView.image = imageToDisplay ?? nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)

        item.itemName = nameField.text
        item.serialNumber = serialField.text
        item.valueInDollars = valueField.text.toInt() ?? 0 //default to 0 dollars if the price is messed up
    }
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.Camera)
        picker.sourceType = isCameraAvailable ? .Camera : .PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    @IBAction func removeImage(sender: AnyObject) {
        //set imageview.image empty
        imageView.image = nil
        //remove image from cache
        item.imageKey >>> BNRImageStore.sharedStore.deleteImageForKey
    }
    @IBAction func backgroundTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage]! as UIImage
        imageView.image = image
        //delete the old image if one exists
        if let key = item.imageKey {
            BNRImageStore.sharedStore.deleteImageForKey(key)
            item.imageKey = nil
        }
        
        //generate a unique ID for the image
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let newUniqueID = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String
        item.imageKey = newUniqueID
        BNRImageStore.sharedStore.setImage(image, forKey: newUniqueID)
        self .dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
