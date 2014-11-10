//
//  AddDailyViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit

class AddDailyViewController: UIViewController {

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    var mainVC: ViewController!
    
    var type: Int = 0 // 0 indicates a DO item, 1 indicates a DON'T item
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    // When the Done button is tapped, add the daily item to the baseArray at the type section
    @IBAction func doneButtonTapped(sender: UIButton) {
        var newDaily = DailyModel(name: self.nameTextField.text, type: self.type)
        
        self.mainVC?.baseArray[self.type].append(newDaily)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
