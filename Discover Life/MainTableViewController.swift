//
//  MainTableViewController.swift
//  Discover Life
//
//  Created by Zhehan Zhang on 2015-07-10.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var placeTypeSearchBar: UISearchBar!
    
    let fixedTypes = ["cafe", "gas", "resterant", "shop", "station"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.typeTableView.delegate = self
        self.typeTableView.dataSource = self
    }

    @IBAction func reset(sender: AnyObject) {
        self.placeTypeSearchBar.text = ""
        self.placeTypeTextField.text = ""
    }
    
    @IBAction func search(sender: AnyObject) {
        if self.placeTypeTextField != "" {
            performSegueWithIdentifier("searchSegue", sender: nil)
        }else {
            // popup UIAlert
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as! MapViewController
        destinationViewController.placeType = self.placeTypeTextField.text
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fixedTypes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = fixedTypes[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.placeTypeTextField.text != "" {
            self.placeTypeTextField.text = self.placeTypeTextField.text + " "
        }
        self.placeTypeTextField.text = self.placeTypeTextField.text + self.fixedTypes[indexPath.row]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
