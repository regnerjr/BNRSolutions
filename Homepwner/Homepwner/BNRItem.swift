import UIKit

class BNRItem : NSObject, NSCoding{
  var itemName: String
  var serialNumber: String
  var valueInDollars: Int
  var dateCreated: NSDate
  var imageKey: String?
  var thumbnail: UIImage?
  var thumbnailData: NSData?{
    willSet{
      thumbnail = (newValue != nil) ? UIImage(data: newValue!) : nil
    }
  }

  override var description: String {
     return "\(itemName) (\(serialNumber)): Worth $\(valueInDollars), recorded on \(dateCreated)"
   }

  init(WithItemName name: String, valueInDollars: Int, serialNumber: String ){
    self.itemName = name
    self.valueInDollars = valueInDollars
    self.serialNumber = serialNumber
    self.dateCreated = NSDate()
    super.init()
  }
  
  convenience init(WithItemName name: String, serialNumber: String){
    self.init(WithItemName: name, valueInDollars: 0, serialNumber: serialNumber)
  }

  convenience override init(){
    self.init(WithItemName: "", valueInDollars: 0, serialNumber: "")
  }

  class func randomItem () -> BNRItem {
    let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
    let randomNounList = ["Bear", "Spork", "Mac"]

    let adjectiveIndex = randomNumberLessThan(randomAdjectiveList.count)
    let nounIndex = randomNumberLessThan(randomNounList.count)
    let randomName = randomAdjectiveList[adjectiveIndex] + randomNounList[nounIndex]

    let randomValue = randomNumberLessThan(100)

    let numbers = Array(0..<10).map{ String($0) }
    let chars = Array(0x61...0x7A).map{String(UnicodeScalar($0))}
    let randomSerialNumber = "\(numbers[randomNumberLessThan(10)])" +
                             "\(chars[randomNumberLessThan(26)])"   +
                             "\(numbers[randomNumberLessThan(10)])" +
                             "\(chars[randomNumberLessThan(26)])"   +
                             "\(numbers[randomNumberLessThan(10)])"
    return BNRItem(WithItemName: randomName, valueInDollars: randomValue,
                    serialNumber: randomSerialNumber)
  }

  func setThumbnailDataFromImage(image: UIImage){

    let newRect = CGRect(x: 0, y: 0, width: 40, height: 40)
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

    if let smallImage = UIGraphicsGetImageFromCurrentImageContext() {
      self.thumbnail = smallImage

      let data = UIImagePNGRepresentation(smallImage)
      self.thumbnailData = data
    }
    UIGraphicsEndImageContext()
  }

  //NSCoding
  required init(coder aDecoder: NSCoder) {
    self.itemName = aDecoder.decodeObjectForKey("itemName") as String
    self.serialNumber = aDecoder.decodeObjectForKey("serialNumber") as String
    self.dateCreated = aDecoder.decodeObjectForKey("dateCreated") as NSDate
    self.imageKey = aDecoder.decodeObjectForKey("imageKey") as? String
    self.valueInDollars = aDecoder.decodeIntegerForKey("valueInDollars")
    self.thumbnailData = aDecoder.decodeObjectOfClass(NSData.classForCoder(), forKey: "thumbnailData") as? NSData
    super.init()
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(itemName, forKey: "itemName")
    aCoder.encodeObject(serialNumber, forKey: "serialNumber")
    aCoder.encodeObject(dateCreated, forKey: "dateCreated")
    aCoder.encodeObject(imageKey, forKey: "imageKey")
    aCoder.encodeInt(Int32(valueInDollars), forKey: "valueInDollars")
    aCoder.encodeObject(thumbnailData, forKey: "thumbnailData")
  }

}

class BNRContainer : BNRItem {
  //properly written can contain instances of BNRContainer
  var subItems = [BNRItem]()
  var collectionValue: Int {
    var sum: Int = 0
    for item in subItems {
      if let container = item as? BNRContainer {
        sum += container.collectionValue
        sum += container.valueInDollars
      }
      else { //else item is just a BNRItem
      sum += item.valueInDollars
      }
    }
    return sum
  }
  
  convenience init(WithContainerName name: String){
    self.init(WithItemName: name, valueInDollars: 0, serialNumber: "")
  }

  func addItem(item:BNRItem) -> (){
    subItems.append(item)
  }

  func description() -> String {
    var items: String = subItems.reduce(""){ $0 + $1.itemName + " "}
    return "Container: \(itemName)\nValue: \(collectionValue)\nWith Items: \(items)"
  }
}
