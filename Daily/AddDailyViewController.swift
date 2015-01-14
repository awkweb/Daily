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
    
  override func viewDidLoad() {
    super.viewDidLoad()
    doneButton.tintColor = UIColor.gray()
    cancelButton.tintColor = UIColor.gray()
    typeSegmentedControl.tintColor = UIColor.green()
    nameTextField.becomeFirstResponder()
  }
  
  @IBAction func typeSegmentedControlChanged(sender: UISegmentedControl) {
    checkSegmentColor()
  }
  
  @IBAction func cancelButtonTapped(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
    nameTextField.resignFirstResponder()
  }
  
  // When the Done button is tapped, add the daily item
  @IBAction func doneButtonTapped(sender: UIButton) {
    
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let managedObjectContext = appDelegate.managedObjectContext
    let entityDescription = NSEntityDescription.entityForName("DailyModel", inManagedObjectContext:managedObjectContext!)
    
    let daily = DailyModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
    
    daily.name = nameTextField.text
    daily.type = typeSegmentedControl.selectedSegmentIndex
    
    appDelegate.saveContext()
    
    var request = NSFetchRequest(entityName: "DailyModel")
    var error: NSError? = nil
    var results: NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
    
    dismissViewControllerAnimated(true, completion: nil)
    nameTextField.resignFirstResponder()
  }

  func checkSegmentColor() {
    if typeSegmentedControl.selectedSegmentIndex == 0 {
      typeSegmentedControl.tintColor = UIColor.green()
    }
    else if typeSegmentedControl.selectedSegmentIndex == 1 {
      typeSegmentedControl.tintColor = UIColor.red()
    }
  }
}
