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
    
    var type = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        var newDaily = DailyModel(name: nameTextField.text, type: self.type)
        
        if newDaily.type == true {
            mainVC?.baseArray[0].append(newDaily)
        }
        else {
            mainVC?.baseArray[1].append(newDaily)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
