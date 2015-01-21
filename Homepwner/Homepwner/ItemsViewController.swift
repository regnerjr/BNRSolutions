import UIKit

class ItemsViewController: UITableViewController {

  convenience override init() {
    self.init(style: UITableViewStyle.Plain)
    configure(navigationItem)
  }

  func configure(navigationItem: UINavigationItem){
    navigationItem.title = "Homepwner"
    let newItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self,
                                  action: Selector("addNewItem:"))
    navigationItem.rightBarButtonItem = newItem
    navigationItem.leftBarButtonItem = editButtonItem()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let nib = UINib(nibName: "HomepwnerItemCell", bundle: nil)
    self.tableView.registerNib(nib,
                               forCellReuseIdentifier: "HomepwnerItemCell")
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  @IBAction func addNewItem(sender: AnyObject) {

    let detailController = DetailViewController(newItem: true)
    let newItem = BNRItemStore.sharedStore.createItem()
    detailController.item = newItem
    detailController.dismissPopoverCompletionBlock = { self.tableView.reloadData() }

    let navController = UINavigationController(rootViewController: detailController)
    navController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
    navController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
    self.presentViewController(navController, animated: true, completion: nil)
    let popPC = navController.popoverPresentationController
  }
    
  @IBAction func toggleEditingMode(sender: AnyObject) {
    let editingButton = sender as UIButton
    //toggle editing
    if editing {
      editingButton.setTitle("Edit", forState: .Normal)
      self.setEditing(false, animated: true)
    }
    else {
      editingButton.setTitle("Done", forState: .Normal)
      self.setEditing(true, animated: true)
    }
  }
}

extension ItemsViewController: UITableViewDataSource {

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return BNRItemStore.sharedStore.getAllItems().count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let p = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier(
                            "HomepwnerItemCell") as HomepwnerItemCell
    cell.nameLabel.text = p.itemName
    cell.serialNumberLabel.text = p.serialNumber
    let currencySymbol = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol) as String!
    cell.valueLabel.text = "\(currencySymbol)\(p.valueInDollars)"
    cell.actionHandlerBlock = { self.showImage(atIndexPath: indexPath) }
    
    func setValueLabelColor(var cell: HomepwnerItemCell, value: Int32) -> HomepwnerItemCell {
      if value > 50{
        cell.valueLabel.textColor = UIColor.greenColor()
      } else {
        cell.valueLabel.textColor = UIColor.redColor()
      }
      return cell
    }
    
    setValueLabelColor(cell, p.valueInDollars)
    cell.thumbnailView.image = p.thumbnail

    return cell
  }

  //MARK: - Editing
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    // If the table view is asking to commit a delete command...
    if editingStyle == .Delete {
      let items = BNRItemStore.sharedStore.getAllItems()
      let p = items[indexPath.row]
      BNRItemStore.sharedStore.removeItem(p)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }

  override func tableView(tableView: UITableView,
                  moveRowAtIndexPath sourceIndexPath: NSIndexPath,
                  toIndexPath destinationIndexPath: NSIndexPath) {

    let itemToMove = BNRItemStore.sharedStore.getAllItems()[sourceIndexPath.row]
    BNRItemStore.sharedStore.moveItem( itemToMove, From: sourceIndexPath.row, toIndex: destinationIndexPath.row)
  }

}

extension ItemsViewController: UITableViewDelegate {

  override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
    return "Remove"
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let detailViewController = DetailViewController(newItem: false)

    let selectedItem = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
    detailViewController.item = selectedItem
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

extension UITableViewController {

  func showImage(atIndexPath indexPath:NSIndexPath){
    //build up a little popover controller and display it. 
    let storyboard = UIStoryboard(name: "imageView", bundle: nil)
    let imageView = storyboard.instantiateInitialViewController() as ImageView
    let item = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
    if item.imageKey != nil {
      let imageFromStore = BNRImageStore.sharedStore.imageForKey(item.imageKey!)
      imageView.imageProperty = imageFromStore
      self.presentViewController(imageView, animated: true, completion: nil)
    }
  }

}