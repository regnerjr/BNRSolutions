import UIKit

class ImageView: UIViewController {

  @IBOutlet weak var theImage: UIImageView!

  var imageProperty: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()
    if imageProperty != nil{
      theImage.image = imageProperty
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
    
  @IBAction func doneLookingAtThisPicture(sender: AnyObject) {
    println("Done button pressed")
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
