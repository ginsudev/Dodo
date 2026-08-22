//
//  HideLockScreenComponentsHooks.swift
//  Dodo
//
//  Created by Noah Little on 12/8/2026.
//

import DodoC
import Shook
import CydiaSubstrate
import AudioToolbox

@HookGroup
final class HideLockScreenComponentsHooks {

    /// Hides background artwork on iOS 16+
    @ClassHook("CSCoverSheetViewController", type: CSCoverSheetViewController.self)
    final class CSCoverSheetViewController_Hook_Background {

        @Hook("_addBackgroundContentViewControllerForAction:")
        func _addBackgroundContentViewControllerForAction(_ action: SBSLockScreenContentAction) {
            guard action.configurationObject.clientBundleIdentifier != "com.apple.MediaRemoteUI" else { return }
            orig._addBackgroundContentViewControllerForAction(action)
        }
    }

    // Hides system media player on iOS 16+
    @ClassHook("CSListItemManager", type: NSObject.self)
    final class CSListItemManager_Hook {

        @Hook("setNowPlayingItem:")
        func setNowPlayingItem(_ item: CSListItem?) {
            orig.setNowPlayingItem(nil)
        }

        @Hook("addItem:")
        func addItem(_ item: CSListItem) {
            guard item.groupingIdentifier != "com.apple.MediaRemoteUI" else { return }
            orig.addItem(item)
        }

        @Hook("updateItem:")
        func updateItem(_ item: CSListItem) {
            guard item.groupingIdentifier != "com.apple.MediaRemoteUI" else { return }
            orig.updateItem(item)
        }
    }
    
    /// Hides system media player on iOS 15+.
    @ClassHook("CSAdjunctListModel", type: CSAdjunctListModel.self)
    final class CSAdjunctListModel_Hook {
        
        @Hook("addOrUpdateItem:")
        func addOrUpdateItem(_ item: AnyObject) {
            // Never show the default ls media player
            guard
                PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .time,
                let _ = item as? CSAdjunctListItem,
                item.identifier == "SBDashBoardNowPlayingAssertionIdentifier"
            else {
                orig.addOrUpdateItem(item)
                return
            }
        }
    }
    
    /// Hides system media player on iOS 14 and lower.
    @ClassHook("CSAdjunctItemView", type: CSAdjunctItemView.self)
    final class CSAdjunctItemView_Hook {
        
        @Hook("initWithFrame:")
        func initWithFrame(_ frame: CGRect) -> CSAdjunctItemView? {
            guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .time else {
                return orig.initWithFrame(frame)
            }
            return nil
        }
    }
    
    /// Hides system time/date view.
    @ClassHook("SBFLockScreenDateView", type: SBFLockScreenDateView.self)
    final class SBFLockScreenDateView_Hook {
        
        @Hook("didMoveToWindow")
        func didMoveToWindow() {
            orig.didMoveToWindow()
            guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .mediaPlayer else { return }
            target.removeFromSuperview()
        }
    }
    
    /// Hides floating quick actions
    @ClassHook("CSQuickActionsView", type: CSQuickActionsView.self)
    final class CSQuickActionsView_Hook {
        
        @Hook("didMoveToWindow")
        func didMoveToWindow() {
            orig.didMoveToWindow()
            target.removeFromSuperview()
        }
    }
    
    /// Hides LS tutorial view (i.e. pull down control centre)
    @ClassHook("CSTeachableMomentsContainerView", type: CSTeachableMomentsContainerView.self)
    final class CSTeachableMomentsContainerView_Hook {
        
        @Hook("didMoveToWindow")
        func didMoveToWindow() {
            orig.didMoveToWindow()
            target.removeFromSuperview()
        }
    }
    
    /// Hides lock icon
    @ClassHook("SBUIProudLockIconView", type: SBUIProudLockIconView.self)
    final class SBUIProudLockIconView_Hook {
        
        @Hook("didMoveToWindow")
        func didMoveToWindow() {
            orig.didMoveToWindow()
            guard PreferenceManager.shared.settings.mediaPlayer.timeMediaPlayerStyle != .mediaPlayer else { return }
            target.removeFromSuperview()
        }
    }
    
    /// Hides swipe to unlock text
    @ClassHook("SBUICallToActionLabel", type: SBUICallToActionLabel.self)
    final class SBUICallToActionLabel_Hook {
        
        @Hook("initWithFrame:")
        func initWithFrame(_ rect: CGRect) -> SBUICallToActionLabel? {
            return nil
        }
    }
    
    /// Hides home bar
    @ClassHook("CSHomeAffordanceView", type: CSHomeAffordanceView.self)
    final class CSHomeAffordanceView_Hook {
        
        @Hook("initWithFrame:")
        func initWithFrame(_ rect: CGRect) -> CSHomeAffordanceView? {
            return nil
        }
    }
    
    /// Hides page dots
    @ClassHook("CSPageControl", type: CSPageControl.self)
    final class CSPageControl_Hook {
        
        @Hook("initWithFrame:")
        func initWithFrame(_ rect: CGRect) -> CSPageControl? {
            return nil
        }
    }
    
    /// Hides charging indicator + date subtitle on battery
    @ClassHook("CSCoverSheetViewController", type: NSObject.self)
    final class CSCoverSheetViewController_Hook_Battery {
        
        // iOS 14
        @Hook("_transitionChargingViewToVisible:showBattery:animated:")
        func _transitionChargingViewToVisible(_ arg1: Bool, showBattery arg2: Bool, animated arg3: Bool) {
            orig._transitionChargingViewToVisible(
                false,
                showBattery: false,
                animated: false
            )
        }
        
        // iOS 15...
        @Hook("_updateDateSubtitleAppearanceForBattery:animated:chargingVisible:")
        func _updateDateSubtitleAppearanceForBattery(_ arg1: Bool, animated arg2: Bool, chargingVisible arg3: Bool) {
            orig._updateDateSubtitleAppearanceForBattery(
                false,
                animated: false,
                chargingVisible: false
            )
        }
    }
}
