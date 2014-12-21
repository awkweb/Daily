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
    
    // COLORS
    var gray = UIColor(red: (62/255.0), green: (62/255.0), blue: (62/255.0), alpha: 1.0)
    var green = UIColor(red: (39/255.0), green: (174/255.0), blue: (96/255.0), alpha: 1.0)
    var red = UIColor(red: (192/255.0), green: (57/255.0), blue: (43/255.0), alpha: 1.0)
    var white = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up navigationBar styling
        self.navigationController?.navigationBar.barTintColor = gray
        self.navigationController?.navigationBar.tintColor = white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: white]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    
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
    
    // Prepare for segues to ViewControllers
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            let detailVC: DailyDetailViewController = segue.destinationViewController as DailyDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisDaily = self.fetchedResultsController.objectAtIndexPath(indexPath!) as DailyModel
            detailVC.detailDailyModel = thisDaily
            detailVC.mainVC = self
        }
        else if segue.identifier == "showAdd" {
            let addDailyVC: AddDailyViewController = segue.destinationViewController as AddDailyViewController
            addDailyVC.mainVC = self
        }
    }
    
    // Check section type if only one section exists. Return the section type, Do = 0 and Don't = 1.
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
    
    // Check if all sections are empty. If empty, add the informational items.
    func checkSectionEmpty() {
        if self.fetchedResultsController.sections!.count == 0 {
            for var sec = 0; sec < 2; sec++ {
                
                let entityDescription = NSEntityDescription.entityForName("DailyModel", inManagedObjectContext:managedObjectContext!)
                
                let daily = DailyModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                
                if sec == 0 {
                    daily.name = "Tap to update me"
                }
                else {
                    daily.name = "Hold and swipe to delete me"
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
    
    // Set section titles
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Change delete button red color to theme red color
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.tableView.editing = false
            
            // Swipe to reveal delete button. Delete item and save context.
            self.managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            
            self.appDelegate.saveContext()
            
            self.checkSectionEmpty()
        }
        
        deleteAction.backgroundColor = red
        
        return [deleteAction]
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

