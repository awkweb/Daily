//
//  ViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
  let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
  var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    navigationController?.navigationBar.barStyle = UIBarStyle.Black
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 75.0
    
    let kScreenRect = UIScreen.mainScreen().bounds
    let smileImage = UIImage(named: "smile") // Image from The Noun Project created by Yolaine Petges
    let hiddenImageView = UIImageView(frame: CGRect(x: kScreenRect.width/2 - 27, y: -75, width: 54, height: 54))
    hiddenImageView.image = smileImage
    tableView.addSubview(hiddenImageView)
    
    let longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
    tableView.addGestureRecognizer(longPress)
    
    fetchedResultsController = getFetchResultsController()
    fetchedResultsController.delegate = self
    fetchedResultsController.performFetch(nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.navigationBar.barTintColor = UIColor.green()
    checkSectionEmpty()
    tableView.reloadData()
  }
  
  // Segue to the AddDailyViewController
  @IBAction func addBarButtonItemTapped(sender: UIBarButtonItem) {
    performSegueWithIdentifier("showAdd", sender: self)
  }
  
  // Prepare for segues to ViewControllers
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
  
  // Check section type if only one section exists. Return the section type, Do = 0 and Don't = 1.
  func checkSectionType() -> Bool {
    var type: Bool = false
    if self.fetchedResultsController.sections!.count == 1 {
      if self.fetchedResultsController.sections![0].numberOfObjects > 0 {
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        var daily = fetchedResultsController.objectAtIndexPath(indexPath) as DailyModel
        type = daily.type.boolValue
      }
    }
    return type
  }
  
  // Check if all sections are empty. If empty, add the informational items.
  func checkSectionEmpty() {
    if fetchedResultsController.sections!.count == 0 {
      for sec in 0..<2 {
        let entityDescription = NSEntityDescription.entityForName("DailyModel", inManagedObjectContext:managedObjectContext!)
        let daily = DailyModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        if sec == 0 {
          daily.name = "Tap to update me"
        }
        else {
          daily.name = "Swipe to delete me"
        }
        daily.type = sec
        appDelegate.saveContext()
      }
    }
  }
  
  // Returns a customized snapshot of the supplied view
  func customSnapshotFromView(inputView: UIView) -> UIView {
    // Make an image from the input view
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
    inputView.layer.renderInContext(UIGraphicsGetCurrentContext())
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // Create an image view
    let snapshot = UIImageView(image: image)
    snapshot.layer.masksToBounds = false
    snapshot.layer.cornerRadius = 0.0
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
    snapshot.layer.shadowRadius = 5.0
    snapshot.layer.shadowOpacity = 0.4
    
    return snapshot
  }
  
  func longPressGestureRecognized(sender: UILongPressGestureRecognizer) {
    let longPress: UILongPressGestureRecognizer = sender
    let state: UIGestureRecognizerState = longPress.state
    let location: CGPoint = longPress.locationInView(tableView)
    let indexPath: NSIndexPath? = tableView.indexPathForRowAtPoint(location)
    
    struct Static {
      static var sourceIndexPath: NSIndexPath?
      static var snapshot: UIView?
    }
    
    switch state {
    case .Began:
      if indexPath != nil {
        Static.sourceIndexPath = indexPath!
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath!)!
        
        // Take a snapshot of the selected row using helper method
        Static.snapshot = customSnapshotFromView(cell)
        
        // Add the snapshot as subview, centered at cell's center
        var center: CGPoint = cell.center
        Static.snapshot!.center = center
        Static.snapshot!.alpha = 0.0
        tableView.addSubview(Static.snapshot!)
        UIView.animateWithDuration(0.25, animations: {
          
          // Offset for gesture location
          center.y = location.y
          Static.snapshot!.center = center
          Static.snapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
          Static.snapshot!.alpha = 0.98
          
          // Fade out
          cell.alpha = 0.0
          }, completion: { finished in
            cell.hidden	= true
        })
      }
    case .Changed:
      var center: CGPoint = Static.snapshot!.center
      center.y = location.y
      Static.snapshot!.center = center
      
      // Is destination valid and different from source?
      if indexPath != nil && indexPath != Static.sourceIndexPath {
        
        // Update data source and move the rows
        tableView.moveRowAtIndexPath(Static.sourceIndexPath!, toIndexPath: indexPath!)
        
        // Update the source
        Static.sourceIndexPath = indexPath
      }
    default:
      
      // Clean up
      let cell: UITableViewCell = tableView.cellForRowAtIndexPath(Static.sourceIndexPath!)!
      cell.hidden = false
      cell.alpha = 0.0
      
      UIView.animateWithDuration(0.25, animations: {
        Static.snapshot!.center = cell.center
        Static.snapshot!.transform = CGAffineTransformIdentity
        Static.snapshot!.alpha = 0.0
        
        // Undo fade out
        cell.alpha = 1.0
        }, completion: { finished in
          Static.snapshot!.removeFromSuperview()
          Static.snapshot = nil
          Static.sourceIndexPath = nil
      })
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.fetchedResultsController.sections!.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.fetchedResultsController.sections![section].numberOfObjects
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let thisDaily = self.fetchedResultsController.objectAtIndexPath(indexPath) as DailyModel
    var cell: DailyCell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as DailyCell
    cell.dailyLabel.text = thisDaily.name
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
  
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
      self.managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
      self.appDelegate.saveContext()
      self.checkSectionEmpty()
    }
    deleteAction.backgroundColor = UIColor.red()
    return [deleteAction]
  }
  
  // Swipe to reveal delete button. Delete item and save context.
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
    appDelegate.saveContext()
    checkSectionEmpty()
  }
}

// MARK: NSFetchResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.tableView.reloadData()
  }
  
  // Fetch
  
  func dailyFetchRequest() -> NSFetchRequest {
    let fetchRequest = NSFetchRequest(entityName: "DailyModel")
    let typeDescriptor = NSSortDescriptor(key: "type", ascending: true)
    fetchRequest.sortDescriptors = [typeDescriptor]
    return fetchRequest
  }
  
  func getFetchResultsController() -> NSFetchedResultsController {
    var fetchedResultsController = NSFetchedResultsController(fetchRequest: dailyFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: "type", cacheName: nil)
    return fetchedResultsController
  }
}

