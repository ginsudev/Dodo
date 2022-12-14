//
//  LSPresentableHostingController.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit
import SwiftUI

final class LSPresentableHostingController<Content>: UIHostingController<Content> where Content: View {
    override func _canShowWhileLocked() -> Bool {
        return true
    }
}
