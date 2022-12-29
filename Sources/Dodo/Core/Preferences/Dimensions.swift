//
//  Dimensions.swift
//  
//
//  Created by Noah Little on 21/12/2022.
//

import UIKit
import DodoC

final class Dimensions: ObservableObject {
    static let shared = Dimensions()
    @Published var isLandscape: Bool = false
    
    var height: CGFloat = 0.0 {
        didSet {
            NotificationCenter.default.post(
                name: NSNotification.Name("Dodo.didUpdateHeight"),
                object: nil
            )
        }
    }
    
    let androBarHeight: CGFloat = {
        GSUtilities.sharedInstance().isAndroBarInstalled()
        ? GSUtilities.sharedInstance().androBarHeight
        : 0
    }()
    
    let statusItemHeight: CGFloat = 18.0
}
