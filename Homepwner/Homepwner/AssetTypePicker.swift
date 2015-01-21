import UIKit
import CoreData

class AssetTypePicker: UITableViewController, UITableViewDataSource, UITableViewDelegate {

  //var assetTypes: [NSManagedObject]?
    var item: BNRItem?
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
    }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfItems = BNRItemStore.sharedStore.getAllAssetTypes()?.count
    return numberOfItems ?? 0
  }

    override func tableView(tableView: UITableView,
      cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier(
          "reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
      
        let assetTypes = BNRItemStore.sharedStore.getAllAssetTypes()
        let assetType = assetTypes?[indexPath.row]
        let label = assetType?.valueForKey("label") as? String
        cell.textLabel?.text = label
        
        if assetType == item?.assetType {
          cell.accessoryType = .Checkmark
        } else {
          cell.accessoryType = .None
        }
        
        return cell
    }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    
    let allAssets = BNRItemStore.sharedStore.getAllAssetTypes()
    let assetType = allAssets?[indexPath.row]
    if let assetType = assetType {
      item?.assetType = assetType
    }

    self.navigationController?.popViewControllerAnimated(true)
  }

}
