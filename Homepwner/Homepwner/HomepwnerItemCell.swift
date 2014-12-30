import UIKit

class HomepwnerItemCell: CellWithActionTableViewCell {

  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var serialNumberLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!

  @IBAction func showImage(sender: AnyObject) {
    self.actionHandlerBlock()
  }

}
