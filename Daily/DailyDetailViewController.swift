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
    
    var mainVC: ViewController!
    
    var detailDailyModel: DailyModel!
    
    var type = true
    
    var reverseType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.detailDailyModel.type == true {
            reverseType = 0
        }
        else if self.detailDailyModel.type == false {
            reverseType = 1
        }
        else {
            reverseType = 0
        }
        
        self.typeSegmentedControl.selectedSegmentIndex = reverseType
        self.nameTextField.text = detailDailyModel.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func typeSegmentedControlChanged(sender: UISegmentedControl) {
        if self.typeSegmentedControl.selectedSegmentIndex == 0 {
            type = true
        }
        else if self.typeSegmentedControl.selectedSegmentIndex == 1 {
            type = false
        }
        else {
            type = true
        }
    }
    
    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        var daily = DailyModel(name: nameTextField.text, type: self.type)
        
        // If daily already exists in baseArray[0], then replace row. If it doesn't append it.
        if daily.type == true {
            self.mainVC.baseArray[0][mainVC.tableView.indexPathForSelectedRow()!.row] = daily
        }
        else {
            self.mainVC.baseArray[1][mainVC.tableView.indexPathForSelectedRow()!.row] = daily
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
