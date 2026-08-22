//
//  LayoutHooks.swift
//  Dodo
//
//  Created by Noah Little on 12/8/2026.
//

import DodoC
import UIKit
import Shook
import CydiaSubstrate

@HookGroup
final class LayoutHooks {
 
    @ClassHook("CSCombinedListViewController", type: CSCombinedListViewController.self)
    final class CSCombinedListViewController_Hook {
        @Property private var dodoController: DDBaseController = .init()
        @Property private var trailingConstraint: NSLayoutConstraint = .init()

        @Hook("viewDidLoad")
        func viewDidLoad() {
            orig.viewDidLoad()
            dodoController.view.translatesAutoresizingMaskIntoConstraints = false
            target.addChild(dodoController)
            target.view.addSubview(dodoController.view)
            dodoController.didMove(toParent: target)

            // Create a reference to the trailing anchor because it changes depending on device orientation.
            trailingConstraint = dodoController.view.trailingAnchor.constraint(equalTo: target.view.trailingAnchor)
            
            // Activate these constraints once.
            NSLayoutConstraint.activate([
                dodoController.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor),
                dodoController.view.leadingAnchor.constraint(equalTo: target.view.leadingAnchor)
            ])
        }

        @Hook("viewWillAppear:")
        func viewWillAppear(_ animated: Bool) {
            orig.viewWillAppear(animated)
            trailingConstraint.isActive = !LocalState.shared.isLandscape
            target.view.setNeedsLayout()
        }
        
        @Hook("_listViewDefaultContentInsets")
        func _listViewDefaultContentInsets() -> UIEdgeInsets {
            var insets = orig._listViewDefaultContentInsets()
            guard !LocalState.shared.isLandscape else { return insets }
            insets.bottom = LocalState.shared.dodoFrame.height + 50
            return insets
        }
    }
}
