//
//  NotificationsLayoutHooks.swift
//  Dodo
//
//  Created by Noah Little on 12/8/2026.
//

import DodoC
import UIKit
import Shook
import CydiaSubstrate

@HookGroup
final class NotificationsLayoutHooks {
    
    // Disables layout from bottom for iOS 16+ notification list
    @ClassHook("NCNotificationMasterList", type: NSObject.self)
    final class NCNotificationMasterList_Hook {
        
        @Hook("isCollapsibleNotificationListSupported")
        func isCollapsibleNotificationListSupported() -> Bool {
            false
        }
    }
    
    // Disables layout from bottom for iOS 16+ notification list (In case master list gets (re)set).
    @ClassHook("NCNotificationListView", type: NSObject.self)
    final class NCNotificationListView_Hook {
        
        @Hook("layoutFromBottom")
        func layoutFromBottom() -> Bool {
            false
        }
    }
    
    // Remove time offset from the listMinY, otherwise big empty gap appears.
    @ClassHook("CSCoverSheetViewController", type: CSCoverSheetViewController.self)
    final class CSCoverSheetViewController_Hook: NSObject {

        @Hook("listMinY")
        func listMinY() -> CGFloat {
            let topBuffer: CGFloat = 20.00
            return (target.view?.safeAreaInsets.top ?? 0.0) + topBuffer
        }
    }
    
    @ClassHook("NCNotificationStructuredListViewController", type: NCNotificationStructuredListViewController.self)
    final class NCNotificationStructuredListViewController_Hook {
        @Property private var cropFrame: CAGradientLayer = .init()
        
        @Hook("viewDidLoad")
        func viewDidLoad() {
            orig.viewDidLoad()
            
            NotificationCenter.default.addObserver(
                target,
                selector: #selector(dodoSetupMask),
                name: .didUpdateHeight,
                object: nil
            )
            
            cropFrame = CAGradientLayer()
            cropFrame.frame = target.view.bounds
            cropFrame.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        }
        
        @Hook("viewDidAppear:")
        func viewDidAppear(_ animated: Bool) {
            orig.viewDidAppear(animated)
            guard !LocalState.shared.isLandscape else {
                target.view.layer.mask = nil
                return
            }
            
            dodoSetupMask()
        }
        
        @New("dodoSetupMask")
        @objc private func dodoSetupMask() {
            target.view.layer.mask = cropFrame
            
            let screenHeight = target.view.bounds.maxY
            let androBarHeight = PreferenceManager.shared.settings.dimensions.androBarHeight
            let startY: CGFloat = (LocalState.shared.dodoFrame.minY - androBarHeight - 50) / screenHeight
            let endY: CGFloat = (LocalState.shared.dodoFrame.minY - androBarHeight) / screenHeight
            
            cropFrame.startPoint = CGPoint(
                x: 0.5,
                y: startY
            )
            
            cropFrame.endPoint = CGPoint(
                x: 0.5,
                y: endY
            )
        }
    }
}
