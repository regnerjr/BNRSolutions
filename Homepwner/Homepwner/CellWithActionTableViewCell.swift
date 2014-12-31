//this is to be used as a base class for cells which should have some action attached to them.
//it was an exercise from the book which is why is does not seem to do much. 

import UIKit

class CellWithActionTableViewCell: UITableViewCell {

  // All cells that have a touch action should inherit from this superclass
  // to have an action handler block, This should be set when the class is 
  // initialized (probably in CellForRowAtIndexPath()
  var actionHandlerBlock: () -> () = {}
}
