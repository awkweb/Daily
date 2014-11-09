//
//  ViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var baseArray: [[DailyModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let daily1 = DailyModel(name: "Stay present", type: true)
        let daily2 = DailyModel(name: "Six sets of twenty push-ups and sit-ups", type: true)
        let daily3 = DailyModel(name: "Set expectations and not meet them", type: false)
        
        var doArray = [daily1, daily2]
        var dontArray = [daily3]
        
        baseArray = [doArray, dontArray]
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Segue to the DailyDetailViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            let detailVC: DailyDetailViewController = segue.destinationViewController as DailyDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisDaily = baseArray[indexPath!.section][indexPath!.row]
            detailVC.detailDailyModel = thisDaily
            detailVC.mainVC = self
        }
        else if segue.identifier == "showAdd" {
            let addDailyVC: AddDailyViewController = segue.destinationViewController as AddDailyViewController
            addDailyVC.mainVC = self
        }
    }
    
    // Segue to the AddDailyViewController
    @IBAction func addBarButtonItemTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAdd", sender: self)
    }
    
    
    // UITableViewDataSource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.baseArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisDaily = baseArray[indexPath.section][indexPath.row]
        
        // Linking prototype cell to ViewController
        var cell: DailyCell = tableView.dequeueReusableCellWithIdentifier("myCell") as DailyCell
        
        cell.dailyLabel.text = thisDaily.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baseArray[section].count
    }
    
    // UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Do"
        }
        else {
            return "Don't"
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.baseArray[indexPath.section].removeAtIndex(indexPath.row)
        self.tableView.reloadData()
    }
    
}

