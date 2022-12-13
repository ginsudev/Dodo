//
//  DDHostingController.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit
import SwiftUI

final class DDHostingController<Content>: UIHostingController<Content> where Content: View {
    override func _canShowWhileLocked() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("[Dodo]: DDHostingController viewDidLoad")
        view.backgroundColor = .clear
    }
}
