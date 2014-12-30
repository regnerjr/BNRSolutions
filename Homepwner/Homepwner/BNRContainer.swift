import UIKit

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
