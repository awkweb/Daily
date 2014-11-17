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
    
    var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set controls equal to the daily item's values
        self.typeSegmentedControl.selectedSegmentIndex = self.detailDailyModel.type.longValue
        self.nameTextField.text = self.detailDailyModel.name
        
        checkSegmentColor()
        
        self.nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func typeSegmentedControlChanged(sender: UISegmentedControl) {
        checkSegmentColor()
    }
    
    // Update the daily item in the appropriate section
    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.detailDailyModel.name = self.nameTextField.text
        self.detailDailyModel.type = self.typeSegmentedControl.selectedSegmentIndex
        
        appDelegate.saveContext()
                
        self.navigationController?.popViewControllerAnimated(true)
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
