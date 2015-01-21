import UIKit
import CoreData
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
  lazy var context = NSManagedObjectContext()
  lazy var model = NSManagedObjectModel.mergedModelFromBundles(nil)

  private var allAssetTypes: [NSManagedObject]?
  lazy var itemArchivePath: String? = {
    if let documentDirectories = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true) as? [String]{

      return documentDirectories[0] + "store.data"
    }
    return nil
  }()

  override init(){
    super.init()
    context.persistentStoreCoordinator =
      makePersistentStoreCoordinator(model: self.model, path: self.itemArchivePath)
    context.undoManager = nil
    self.loadAllItems()
  }

  func loadAllItems(){
    if allItems.count == 0 {
      let request = NSFetchRequest(entityName: "BNRItem")
      //let sd = NSSortDescriptor(key: "orderingValue", ascending: true)
      //request.sortDescriptors = [sd]
      
      var e: NSError?
      let result = context.executeFetchRequest(request, error: &e) as [BNRItem]?
      
      if let results = result {
        allItems = results
      } else {
        println("Could not fetch \(e), \(e!.userInfo)")
      }
      
    }
  }
  
  func getAllAssetTypes() -> [NSManagedObject]?{
    
    if allAssetTypes == nil {
      let request = NSFetchRequest(entityName: "BNRAssetType")
      var e: NSError?
      let result = context.executeFetchRequest(request, error: &e) as [NSManagedObject]?
      
      if let results = result {
        //got something back
        allAssetTypes = results
      }
    }
    
    if allAssetTypes?.count == 0 {
      let newTypes: [NSManagedObject] = ["Furniture", "Jewelry", "Electronics"].map ({
        let type = NSEntityDescription.insertNewObjectForEntityForName("BNRAssetType", inManagedObjectContext: self.context) as NSManagedObject
          type.setValue($0, forKey: "label")
        return type
      })
      //still not sure why allAssetTypes += newTypes does not work. Pretty sure I can add arrays?!?
      for type in newTypes {
        allAssetTypes?.append(type)
      }
    }
    return allAssetTypes
  }
  
  func saveChanges() -> Bool {
    var error: NSError?
    let success = context.save(&error)
    if success == false {
      println("Error Saving: \(error?.localizedDescription)")
    }
    return success
  }

  func createItem() -> BNRItem {
    let p = BNRItem(entity: NSEntityDescription.entityForName("BNRItem", inManagedObjectContext: self.context)!, insertIntoManagedObjectContext: self.context)
    p.orderingValue = calculateOrderingValue(allItems)
    p.itemName = ""
    p.serialNumber = ""
    p.valueInDollars = 0

    allItems.append(p)
    return p
  }

  func getAllItems() -> [BNRItem] {
    return allItems
  }

  func removeItem(p: BNRItem) {
    BNRImageStore.sharedStore.deleteImageForKey <^> p.imageKey
    allItems = allItems.filter{$0 !== p}
    context.deleteObject(p)
  }

  func moveItem(p: BNRItem, From from: Int, toIndex to: Int){
    if from == to {return}
    p.orderingValue = calculateOrderingValueForMoveTo(to, inArray: allItems)
    allItems.removeAtIndex(from)
    allItems.insert(p, atIndex: to)
  }
}

func calculateOrderingValue(items: [BNRItem]) -> Double {
  if items.count == 0 {
    return 1.0
  } else {
    return items[items.count - 1].orderingValue + 1.0
  }
}

func calculateOrderingValueForMoveTo(to: Int, inArray items: [BNRItem]) -> Double {
  var lowerBound = 0.0
  if to > 0 {
    lowerBound = items[to - 1].orderingValue
  } else {
    lowerBound = items[1].orderingValue - 2.0
  }
  var upperBound = 0.0
  if to < items.count - 1 {
    upperBound = items[to + 1].orderingValue
  } else {
    upperBound = items[to - 1].orderingValue + 2.0
  }
  return (lowerBound + upperBound) / 2.0
}

func makePersistentStoreCoordinator(#model: NSManagedObjectModel?,
                              #path: String?) -> NSPersistentStoreCoordinator? {
  if let model = model {
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    if let path = path {
      let storeURL = NSURL(fileURLWithPath: path)
      
      var error: NSError?
      if psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil,
                            URL: storeURL, options: nil, error: &error) == nil {
          //Help there was an error
          //log it and quit
          println(
            "OMG There was some error setting up you Persistent store.Error: \(error?.userInfo)")
          abort()
      }//psc
      return psc
    }//path?
  }//model?
  return nil
}