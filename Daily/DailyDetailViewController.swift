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
    
    var type: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typeSegmentedControl.selectedSegmentIndex = self.detailDailyModel.type.longValue
        self.nameTextField.text = self.detailDailyModel.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // When the UISegmentedConrol is changed, update the type value
    @IBAction func typeSegmentedControlChanged(sender: UISegmentedControl) {
        if self.typeSegmentedControl.selectedSegmentIndex == 0 {
            self.type = 0
        }
        else if self.typeSegmentedControl.selectedSegmentIndex == 1 {
            self.type = 1
        }
        else {
            self.type = 0
        }
    }
    
    // Update the daily item in the appropriate section
    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.detailDailyModel.name = self.nameTextField.text
        self.detailDailyModel.type = self.type
        
//        if daily.type == self.detailDailyModel.type {
//            self.mainVC?.baseArray[daily.type][self.mainVC.tableView.indexPathForSelectedRow()!.row] = daily
//        }
//        else {
//            self.mainVC?.baseArray[detailDailyModel.type].removeAtIndex(self.mainVC.tableView.indexPathForSelectedRow()!.row)
//            self.mainVC?.baseArray[daily.type].append(daily)
//        }
        
        appDelegate.saveContext()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
