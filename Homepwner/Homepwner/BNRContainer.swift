import UIKit

class BNRContainer : BNRItem {

  //properly written can contain instances of BNRContainer
  var subItems = [BNRItem]() //since BNRItem is a superclass of BNRContainer this will be able to contain containers.
  //computed property which recuriively finds the value of a container.
  var collectionValue: Int32 {
    var sum: Int32 = 0
    for item in subItems {
      if let container = item as? BNRContainer { //yeah downcast!
        sum += container.collectionValue
        sum += container.valueInDollars
      }
      else { //else item is just a BNRItem
        sum += item.valueInDollars
      }
    }
    return sum
  }
    
  func addItem(item:BNRItem) -> (){
    subItems.append(item)
  }
  
  func description() -> String {
    var items: String = subItems.reduce(""){ $0 + $1.itemName + " "}
    return "Container: \(itemName)\nValue: \(collectionValue)\nWith Items: \(items)"
  }
}
