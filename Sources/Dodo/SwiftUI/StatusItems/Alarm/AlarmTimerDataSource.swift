//
//  AlarmTimerDataSource.swift
//  
//
//  Created by Noah Little on 7/1/2023.
//

import Foundation
import Orion
import DodoC

struct DDAlarm: Identifiable {
    let id: UUID
    let url: URL
    let nextFireDate: Date
    let displayTitle: String
    let isEnabled: Bool
}

final class AlarmTimerDataSource: ObservableObject {
    static let shared = AlarmTimerDataSource()
    
    private var alarmCache: MTAlarmCache? = {
        if let observer = SBScheduledAlarmObserver.sharedInstance() {
            let manager = Ivars<MTAlarmManager>(observer)._alarmManager
            return manager.cache
        } else {
            return nil
        }
    }()
    
    @Published var nextEnabledAlarm: DDAlarm?
    
    @Published var alarms = [DDAlarm]() {
        didSet {
            nextEnabledAlarm = alarms.first(where: \.isEnabled)
        }
    }
    
    func updateAlarms() {
        if let cache = self.alarmCache,
           let orderedAlarms = cache.orderedAlarms as? [MTAlarm] {
            let alarms = orderedAlarms
                .compactMap { self.convertMobileAlarm($0) }
            DispatchQueue.main.async {
                self.alarms = alarms
            }
        }
    }
    
    private func convertMobileAlarm(_ alarm: MTAlarm) -> DDAlarm {
        .init(
            id: alarm.alarmID,
            url: alarm.alarmURL,
            nextFireDate: alarm.nextFireDate,
            displayTitle: alarm.displayTitle,
            isEnabled: alarm.isEnabled
        )
    }
}
