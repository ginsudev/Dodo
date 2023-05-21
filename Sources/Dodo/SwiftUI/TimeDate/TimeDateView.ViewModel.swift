//
//  TimeDateView.ViewModel.swift
//  
//
//  Created by Noah Little on 21/5/2023.
//

import Foundation
import GSCore

// MARK: - Internal

extension TimeDateView {
    final class ViewModel: ObservableObject {
        @Published private(set) var isDisplayingPrimary: Bool = true
        @Published private(set) var timeString = "--:--"
        @Published private(set) var dateString = "--/--/--"
        @Published var isDisplayingLocationName: Bool = false
        
        private let dualClock: DualClock = .init()
        let settings = PreferenceManager.shared.settings

        var timeZone: TimeZone {
            guard dualClock.isInstalledAndEnabled,
                  let primary = TimeZone(identifier: dualClock.primaryTimeZoneID),
                  let secondary = TimeZone(identifier: dualClock.secondaryTimeZoneID)
            else { return .autoupdatingCurrent }
            return isDisplayingPrimary
            ? primary
            : secondary
        }
        
        var locationImageName: String? {
            guard dualClock.isInstalledAndEnabled else { return nil }
            return isDisplayingPrimary
            ? "house.fill"
            : "location.fill"
        }
        
        var locationName: String? {
            guard dualClock.isInstalledAndEnabled else { return nil }
            return (
                isDisplayingPrimary
                ? dualClock.primaryName.nilIfEmpty
                : dualClock.secondaryName.nilIfEmpty
            ) ?? timeZone.identifier.components(separatedBy: "/").last
        }
        
        func onDidTapTime() {
            guard dualClock.isInstalledAndEnabled, !isDisplayingLocationName else { return }
            isDisplayingPrimary.toggle()
            isDisplayingLocationName = true
            HapticManager.playHaptic(withIntensity: .custom(.light))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.isDisplayingLocationName = false
            }
        }
        
        func refreshTime() {
            if let time = settings.timeDate.timeTemplate.dateString(timeZone: timeZone) {
                timeString = time
            }
            if let date = settings.timeDate.dateTemplate.dateString(timeZone: timeZone) {
                dateString = date
            }
        }
    }
}
