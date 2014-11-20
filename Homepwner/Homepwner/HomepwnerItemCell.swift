//
//  HomepwnerItemCell.swift
//  Homepwner
//
//  Created by John Regner on 11/18/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

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
