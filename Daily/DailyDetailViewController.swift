//
//  DailyDetailViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit

class DailyDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var mainVC: ViewController!
    
    var detailDailyModel: DailyModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.text = detailDailyModel.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        var daily = DailyModel(name: nameTextField.text, type: true)
        
        self.mainVC.baseArray[0][mainVC.tableView.indexPathForSelectedRow()!.row] = daily
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
