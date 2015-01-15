//
//  DailyDetailViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit

class DailyDetailViewController: UIViewController {
  
  @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var nameTextField: UITextField!
  
  var detailDailyModel: DailyModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    typeSegmentedControl.selectedSegmentIndex = detailDailyModel.type.longValue
    nameTextField.text = detailDailyModel.name
    checkSegmentColor()
    nameTextField.textColor = UIColor.gray()
    nameTextField.becomeFirstResponder()
  }
  
  @IBAction func typeSegmentedControlChanged(sender: UISegmentedControl) {
    checkSegmentColor()
  }
  
  // Update the daily item in the appropriate section
  @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    detailDailyModel.name = nameTextField.text
    detailDailyModel.type = typeSegmentedControl.selectedSegmentIndex

    appDelegate.saveContext()
    
    navigationController?.popViewControllerAnimated(true)
  }
    
  func checkSegmentColor() {
    if typeSegmentedControl.selectedSegmentIndex == 0 {
      typeSegmentedControl.tintColor = UIColor.green()
      navigationController?.navigationBar.barTintColor = UIColor.green()
    }
    else if typeSegmentedControl.selectedSegmentIndex == 1 {
      typeSegmentedControl.tintColor = UIColor.red()
      navigationController?.navigationBar.barTintColor = UIColor.red()
    }
  }
}
