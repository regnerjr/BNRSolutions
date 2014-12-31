import UIKit

class ImageView: UIViewController {

  @IBOutlet weak var theImage: UIImageView!
  var imageProperty: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()
    theImage.image = imageProperty
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
    
  @IBAction func doneLookingAtThisPicture(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

//allow the image view to be scrolled and zoomed
extension ImageView: UIScrollViewDelegate {
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return theImage
  }
}