import UIKit
import JROperators

class DetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var assetTypeButton: UIButton!

    var dismissPopoverCompletionBlock: (()-> Void)?
    var item: BNRItem! {  //will be loaded when this view is pushed onto the view controller
        didSet{
            navigationItem.title = self.item.itemName
            }
    }

  //MARK: - Initializers
  
    init(newItem:Bool){
        super.init(nibName: "DetailViewController", bundle: nil)
        if newItem {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "save:")
            self.navigationItem.rightBarButtonItem = doneButton

            let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
            self.navigationItem.leftBarButtonItem = cancelButton
        }
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Use the init(newItem:) initializer")
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  //MARK: - View Lifecycle
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.itemName
        serialField.text = item.serialNumber
        valueField.text = "\(item.valueInDollars)"

        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        let date = NSDate(timeIntervalSinceReferenceDate: item.dateCreated)
        dateLabel.text = formatter.stringFromDate(date)      
        imageView.image = item.imageKey >>=- BNRImageStore.sharedStore.imageForKey
      
        let typelabel = item.assetType.valueForKey("label") as? String
        let type = typelabel ?? "None"
        assetTypeButton.titleLabel?.text = "Type:" + type
      
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
      
      //save any changes made by the user
        item.itemName = nameField.text
        item.serialNumber = serialField.text
        item.valueInDollars = Int32(valueField.text.toInt() ?? 0) //default to 0 dollars if the price is messed up
        item.thumbnail = item.getThumbnailFromImage(40)(image: imageView.image)
        BNRItemStore.sharedStore.saveChanges() //save all changes to the core data store
    }
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.Camera)
        picker.sourceType = isCameraAvailable ? .Camera : .PhotoLibrary
        picker.delegate = self

        //set up the picker view in a popover controller
        picker.modalPresentationStyle = UIModalPresentationStyle.Popover;
        self.presentViewController(picker, animated: true, completion: nil)
        //configure the popover
        let popPC = picker.popoverPresentationController
        popPC?.barButtonItem = self.cameraBarButtonItem
        popPC?.permittedArrowDirections = UIPopoverArrowDirection.Any
        popPC?.delegate = self
    }

    @IBAction func backgroundTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }

    func save(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: self.dismissPopoverCompletionBlock)
    }

    func cancel(sender:AnyObject){
        BNRItemStore.sharedStore.removeItem(item)
        self.save(sender)
    }
  
    @IBAction func showAssetTypePicker(sender: AnyObject) {
      self.view.endEditing(true)
      let storyboard = UIStoryboard(name: "imageView", bundle: nil)
      let assetTypePicker = storyboard.instantiateViewControllerWithIdentifier("AssetTypePicker") as AssetTypePicker
      
      assetTypePicker.item = item
      self.navigationController?.pushViewController(assetTypePicker, animated: true)
    }
    
}



extension DetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailViewController { //override rotation values

    override func shouldAutorotate() -> Bool {
        return true
    }
  
    override func supportedInterfaceOrientations() -> Int {
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        let mask =  (idiom == .Pad) ? UIInterfaceOrientationMask.All : UIInterfaceOrientationMask.AllButUpsideDown
        return Int(mask.rawValue)
    }
} // override rotation values

extension DetailViewController: UIPopoverPresentationControllerDelegate {

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        println("Popover was dismissed")
    }

    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }

}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            let image = info[UIImagePickerControllerOriginalImage]! as UIImage
            imageView.image = image
            //delete the old image if one exists
            if item.imageKey != nil{
                BNRImageStore.sharedStore.deleteImageForKey(item.imageKey!)
                item.imageKey = nil
            }

            //generate a unique ID for the image
            let uuid = CFUUIDCreate(kCFAllocatorDefault)
            let newUniqueID = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String
            item.imageKey = newUniqueID
            BNRImageStore.sharedStore.setImage(image, forKey: newUniqueID)
            self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
