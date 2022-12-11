//
//  DodoPickerController.swift
//  
//
//  Created by Noah Little on 24/7/2022.
//

import UIKit
import Preferences

class DodoPickerController: PSListItemsController {
    override func tableViewStyle() -> UITableView.Style {
        if #available(iOS 13.0, *) {
            return .insetGrouped
        } else {
            return .grouped
        }
    }
}
