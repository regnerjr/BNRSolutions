import UIKit

class HomepwnerItemCell: UITableViewCell {

  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var serialNumberLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  weak var controller: UITableViewController?
  weak var tableView: UITableView?
  
  @IBAction func showImage(sender: AnyObject) {
    if let indexpath = tableView?.indexPathForCell(self){
      controller?.showImage(sender, atIndexPath:indexpath)
      //needs to have this method defined in a custom extenstion of UITableViewController
    }
  }

}
