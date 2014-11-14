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
        
        // Set controls equal to the daily item's values
        self.typeSegmentedControl.selectedSegmentIndex = self.detailDailyModel.type.longValue
        self.nameTextField.text = self.detailDailyModel.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Update the daily item in the appropriate section
    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.detailDailyModel.name = self.nameTextField.text
        self.detailDailyModel.type = self.typeSegmentedControl.selectedSegmentIndex
        
        appDelegate.saveContext()
                
        self.navigationController?.popViewControllerAnimated(true)
    }
}
