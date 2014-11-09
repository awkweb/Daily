//
//  AddDailyViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit

class AddDailyViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        var newDaily = DailyModel(name: nameTextField.text, type: true)
        mainVC?.baseArray[0].append(newDaily)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
