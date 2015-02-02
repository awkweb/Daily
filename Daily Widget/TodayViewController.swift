//
//  TodayViewController.swift
//  Daily Widget
//
//  Created by thomas on 2/2/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var launchDailyButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    launchDailyButton.backgroundColor = UIColor(red: (39/255.0), green: (174/255.0), blue: (96/255.0), alpha: 1.0)
    launchDailyButton.tintColor = UIColor.whiteColor()
    launchDailyButton.layer.cornerRadius = 8.0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    completionHandler(NCUpdateResult.NewData)
  }
  
  @IBAction func launchDailyButtonPressed(sender: UIButton) {
    extensionContext!.openURL(NSURL(string: "DailyApp://")!, completionHandler: nil)
  }
}
