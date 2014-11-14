//
//  AddDailyViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit
import CoreData

class AddDailyViewController: UIViewController {

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // When the Done button is tapped, add the daily item
    @IBAction func doneButtonTapped(sender: UIButton) {
        
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("DailyModel", inManagedObjectContext:managedObjectContext!)
        
        let daily = DailyModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        daily.name = self.nameTextField.text
        daily.type = self.typeSegmentedControl.selectedSegmentIndex // 0 indicates a DO item, 1 indicates a DON'T item
        
        // Save changes to the entity
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "DailyModel")
        var error: NSError? = nil
        var results: NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
                
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
