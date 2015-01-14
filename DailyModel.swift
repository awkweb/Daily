//
//  DailyModel.swift
//  Daily
//
//  Created by thomas on 11/10/14.
//  Copyright (c) 2014 thomas. All rights reserved.
//

import Foundation
import CoreData

@objc(DailyModel)
class DailyModel: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var type: NSNumber
}
