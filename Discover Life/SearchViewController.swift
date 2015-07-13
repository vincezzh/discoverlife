//
//  SearchViewController.swift
//  Discover Life
//
//  Created by Zhehan Zhang on 2015-07-11.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var typeSearchBar: UISearchBar!
    @IBOutlet weak var typeKeywords: UITextField!
    
    let types = ["Cafe", "Gas", "Resterant", "Shop", "Station"]
    var filtered: [String] = []
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.typeTableView.delegate = self
        self.typeTableView.dataSource = self
        self.typeSearchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtered = self.types.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if filtered.count == 0 {
            self.searchActive = false;
        } else {
            self.searchActive = true;
        }
        self.typeTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return self.filtered.count
        }
        return self.types.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        if(self.searchActive){
            cell.textLabel?.text = self.filtered[indexPath.row]
        } else {
            cell.textLabel?.text = self.types[indexPath.row];
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.typeKeywords.text != "" {
            self.typeKeywords.text = self.typeKeywords.text + " "
        }
        self.typeKeywords.text = self.typeKeywords.text + self.types[indexPath.row]
    }
    
    @IBAction func reset(sender: AnyObject) {
        self.typeKeywords.text = ""
        self.typeSearchBar.text = ""
    }

    @IBAction func search(sender: AnyObject) {
        if self.typeKeywords != "" {
            performSegueWithIdentifier("showMap", sender: nil)
        }else {
            // popup UIAlert
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as! MapViewController
        destinationViewController.placeType = self.typeKeywords.text
    }

}
