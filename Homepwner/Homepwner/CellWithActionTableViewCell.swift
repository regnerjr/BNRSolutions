import UIKit

class CellWithActionTableViewCell: UITableViewCell {

  // All cells that have a touch action should inherit from this superclass
  // to have an action handler block, This should be set when the class is 
  // initialized (probably in CellForRowAtIndexPath()
  var actionHandlerBlock: () -> () = {}
}
