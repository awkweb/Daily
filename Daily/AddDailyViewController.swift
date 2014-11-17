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
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!

    
    var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up element styling
        self.doneButton.tintColor = self.mainVC.gray
        self.cancelButton.tintColor = self.mainVC.gray
        self.typeSegmentedControl.tintColor = self.mainVC.green
        
        self.nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func typeSegmentedControlChanged(sender: UISegmentedControl) {
        checkSegmentColor()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.nameTextField.resignFirstResponder()
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
        self.nameTextField.resignFirstResponder()
    }
    
    // HELPERS
    
    // Check for typeSegmentedControl tintColor
    func checkSegmentColor() {
        if self.typeSegmentedControl.selectedSegmentIndex == 0 {
            self.typeSegmentedControl.tintColor = self.mainVC.green
        }
        else if self.typeSegmentedControl.selectedSegmentIndex == 1 {
            self.typeSegmentedControl.tintColor = self.mainVC.red
        }
    }
}
