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
    
    var dailyArray: [DailyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let daily1 = DailyModel(name: "Be honest")
        let daily2 = DailyModel(name: "Be positive")
        let daily3 = DailyModel(name: "Be polite")
        
        dailyArray = [daily1, daily2, daily3]
        
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
            let thisDaily = dailyArray[indexPath!.row]
            detailVC.detailDailyModel = thisDaily
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisDaily = dailyArray[indexPath.row]
        
        // Linking prototype cell to ViewController
        var cell: DailyCell = tableView.dequeueReusableCellWithIdentifier("myCell") as DailyCell
        
        cell.dailyLabel.text = thisDaily.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyArray.count
    }
    
    // UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetails", sender: self)
    }
    
}

