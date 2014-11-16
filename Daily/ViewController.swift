//
//  ViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchedResultsController = getFetchResultsController()
        self.fetchedResultsController.delegate = self
        self.fetchedResultsController.performFetch(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkSectionEmpty()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Segue to the AddDailyViewController
    @IBAction func addBarButtonItemTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAdd", sender: self)
    }
    
    // Segue to ViewControllers
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            let detailVC: DailyDetailViewController = segue.destinationViewController as DailyDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisDaily = self.fetchedResultsController.objectAtIndexPath(indexPath!) as DailyModel
            detailVC.detailDailyModel = thisDaily
        }
        else if segue.identifier == "showAdd" {
            let addDailyVC: AddDailyViewController = segue.destinationViewController as AddDailyViewController
        }
    }
    
    // Check section type if only one section exists
    func checkSectionType() -> Bool {
        var type: Bool = false
        
        if self.fetchedResultsController.sections!.count == 1 {
            if self.fetchedResultsController.sections![0].numberOfObjects > 0 {
                var indexPath = NSIndexPath(forItem: 0, inSection: 0)
                var daily = self.fetchedResultsController.objectAtIndexPath(indexPath) as DailyModel
                type = daily.type.boolValue
            }
        }
        
        return type
    }
    
    // Check if section is empty
    func checkSectionEmpty() {
        if self.fetchedResultsController.sections!.count == 0 {
            for var sec = 0; sec < 2; sec++ {
                
                let entityDescription = NSEntityDescription.entityForName("DailyModel", inManagedObjectContext:managedObjectContext!)
                
                let daily = DailyModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                
                if sec == 0 {
                    daily.name = "Tap me to add a DO item"
                }
                else {
                    daily.name = "Tap me to add a DON'T item"
                }
                
                daily.type = sec
                
                appDelegate.saveContext()
            }
        }
    }
    
    
    // UITABLEVIEWDATASOURCE FUNCTIONS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisDaily = self.fetchedResultsController.objectAtIndexPath(indexPath) as DailyModel
        
        // Linking prototype cell to ViewController
        var cell: DailyCell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as DailyCell
        
        cell.dailyLabel.text = thisDaily.name
        
        return cell
    }
    
    // UITABLEVIEWDELEGATE FUNCTIONS
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if checkSectionType() {
                return "Don't"
            }
            else {
                return "Do"
            }
        }
        else {
            return "Don't"
        }
    }
    
    // Swipe to reveal delete button. Delete item and save context.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
        
        appDelegate.saveContext()
        
        checkSectionEmpty()
    }
    
    // NSFETCHEDRESULTSCONTROLLER FUNCTIONS
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    // Fetch
    
    func dailyFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "DailyModel")
        let typeDescriptor = NSSortDescriptor(key: "type", ascending: true)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [typeDescriptor,nameDescriptor]
        return fetchRequest
    }
    
    func getFetchResultsController() -> NSFetchedResultsController {
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: dailyFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: "type", cacheName: nil)
        
        return fetchedResultsController
    }
    
}

