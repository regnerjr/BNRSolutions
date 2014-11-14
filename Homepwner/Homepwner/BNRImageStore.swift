import UIKit

private let _BNRImageStoreSharedStore = BNRImageStore()

//Use this by calling BNRItemStore.sharedStore to get the Singleton Object. 
//It will be instantiated lazily the first time it is called.

class BNRImageStore: NSObject {

  private var imageDictionary = [String:UIImage]()

  //class variable with only a computed getter returning the private var
  class var sharedStore: BNRImageStore {
    return _BNRImageStoreSharedStore
  }

  override init(){
    super.init()
    let nc = NSNotificationCenter.defaultCenter()
    nc.addObserver(self, selector: Selector("clearCache:"),
      name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
  }

  deinit{
    let nc = NSNotificationCenter.defaultCenter()
    nc.removeObserver(self,
      name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
  }

  //in an effort for later expansion and test, these should all return something.
  func setImage(image:UIImage, forKey key: String) -> Dictionary<String,UIImage>{
    imageDictionary[key] = image

    let imagePath = imagePathForKey(key)
    let data = UIImagePNGRepresentation(image)
    data.writeToFile(imagePath, atomically: true)
    return imageDictionary
  }
  
  func imageForKey(key: String) -> UIImage? {
    return imageDictionary[key] ?? UIImage(contentsOfFile: self.imagePathForKey(key)) ?? nil
  }
  
  func deleteImageForKey(key: String) -> Dictionary<String,UIImage>{
    imageDictionary.removeValueForKey(key)

    let path = imagePathForKey(key)
    NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
    return imageDictionary
  }


  func imagePathForKey(key: String) -> String {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask, true) as [String]
    return documentsDirectory[0] + key
  }

  func clearCache(note:NSNotification) {
    println("flushing \(imageDictionary.count) images out of cache")
    imageDictionary.removeAll(keepCapacity: false)
  }


}//end class
