//
//  DailyDetailViewController.swift
//  Daily
//
//  Created by thomas on 11/6/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import UIKit

class DailyDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    
    var detailDailyModel: DailyModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = detailDailyModel.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
