import Foundation
import CoreData
import UIKit

func imageFromData(a: NSData?) -> UIImage? {
  //can't use bind here because I can not figure out how to get a reference to
  //the initializer method, would love for this to be a >>=- UIImage.initWithData
  switch a {
  case .Some(let data): return UIImage(data: data)
  case .None: return nil
  }
}

class BNRItem: NSManagedObject {

  @NSManaged var itemName: String
  @NSManaged var serialNumber: String
  @NSManaged var valueInDollars: Int32
  @NSManaged var dateCreated: NSTimeInterval
  @NSManaged var imageKey: String?
  @NSManaged var thumbnailData: NSData?
  var thumbnail: UIImage? = nil {
    willSet {
      //set the thumbnail data based on this new thumbnail image.
      self.thumbnailData = UIImagePNGRepresentation(newValue)
    }
  }
  @NSManaged var orderingValue: Double
  @NSManaged var assetType: NSManagedObject
  
  func getThumbnailFromImage(size: Int)(image: UIImage?) -> UIImage?{
    if let image = image { //don't do any setting here if image is nil
      let newRect = CGRect(x: 0, y: 0, width: size, height: size)
      UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)
      let path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
      path.addClip()
      
      let originalImageSize = image.size
      let ratio = max(newRect.size.width / originalImageSize.width,
        newRect.size.height / originalImageSize.height)
      
      var projectRect = CGRect()
      projectRect.size.width = ratio * originalImageSize.width
      projectRect.size.height = ratio * originalImageSize.height
      projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0
      projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0
      image.drawInRect(projectRect)
      
      let smallImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return smallImage
    }
    return nil // if no image passed in return nil
  }

  override func awakeFromFetch() {
    super.awakeFromFetch()
    //since thumbnail is not archived make a new one based on the data that was archived
    if let thumbnailData = thumbnailData {
      self.thumbnail = UIImage(data: thumbnailData)
    }
  }
  override func awakeFromInsert() {
    super.awakeFromInsert()
    let t = NSDate.timeIntervalSinceReferenceDate()
    self.dateCreated = t
    //other properties are set in BNRStore.createItem()
  }
}


extension BNRItem: Printable {
  override var description: String {
    return "\(itemName) (\(serialNumber)): Worth $\(valueInDollars), recorded on \(dateCreated)"
  }
}