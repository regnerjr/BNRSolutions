import UIKit
import JROperators

private let _BNRItemStoreSharedStore = BNRItemStore()

//Use this by calling BNRItemStore.sharedStore to get the Singleton Object. 
//It will be instantiated lazily the first time it is called.

class BNRItemStore: NSObject {

  //class variable with only a computed getter returning the private var
  class var sharedStore: BNRItemStore {
    return _BNRItemStoreSharedStore
  }

  private var allItems = [BNRItem]()

  var itemArchivePath: String? {
    if let documentDirectories = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true) as? [String]{

      return documentDirectories[0] + "items.archive"
    }
    return nil
  }

  override init(){
    super.init()
    let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile <^> itemArchivePath
    if let archivedBNRItems = archivedItems as? [BNRItem] {
      allItems = archivedBNRItems
      //nothing to archive because the path is
      //invalid, leave it as the empty array.
    }
  }

  func saveChanges() -> Bool{
    if itemArchivePath != nil {
      return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchivePath!)
    }
    println("invalid item archive path. Can't save changes!")
    return false
  }

  func createItem() -> BNRItem {
    //let p = BNRItem.randomItem()
    let p = BNRItem()
    allItems.append(p)
    return p
  }

  func getAllItems() -> [BNRItem] {
    return allItems
  }

  func removeItem(p: BNRItem ) {
    BNRImageStore.sharedStore.deleteImageForKey <^> p.imageKey
    allItems = allItems.filter{$0 !== p}
  }

  func moveItem(from: Int, toIndex to: Int){
    if from == to {return}
    let p = allItems[from]
    allItems.removeAtIndex(from)
    allItems.insert(p, atIndex: to)
  }
}
