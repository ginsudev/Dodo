//
//  AlarmTimerManager.swift
//  
//
//  Created by Noah Little on 7/1/2023.
//

import Foundation
import Combine
import Orion
import DodoC

// MARK: - Internal

final class AlarmTimerManager: ObservableObject {
    private static let nextAlarmKey = "NextAlarm"
    private static let nextTimerKey = "NextTimer"
    
    @Published private(set) var nextTimer: Timer? = PreferenceManager.shared.defaults.timer(forKey: Keys.nextTimer) {
        didSet {
            PreferenceManager.shared.defaults.set(timer: nextTimer, forKey: Keys.nextTimer)
        }
    }
    
    @Published private(set) var nextAlarm: Alarm? = PreferenceManager.shared.defaults.alarm(forKey: Keys.nextAlarm) {
        didSet {
            PreferenceManager.shared.defaults.set(alarm: nextAlarm, forKey: Keys.nextAlarm)
        }
    }
    
    init() {
        subscribe()
    }
}

// MARK: - Private

private extension AlarmTimerManager {
    func subscribe() {
        NotificationCenter.default.publisher(for: .didChangeNextAlarm)
            .receive(on: DispatchQueue.main)
            .map { [weak self] in
                guard let alarm = $0.userInfo?[Self.nextAlarmKey] as? MTAlarm else { return nil }
                return self?.convert(alarm: alarm)
            }
            .assign(to: &$nextAlarm)
        
        NotificationCenter.default.publisher(for: .didChangeNextTimer)
            .receive(on: DispatchQueue.main)
            .map { [weak self] in
                guard let timer = $0.userInfo?[Self.nextTimerKey] as? MTTimer else { return nil }
                return self?.convert(timer: timer)
            }
            .assign(to: &$nextTimer)
    }
    
    func convert(alarm: MTAlarm?) -> Alarm? {
        guard let alarm else { return nil }
        return .init(
            id: alarm.alarmID,
            url: alarm.alarmURL,
            nextFireDate: alarm.nextFireDate,
            displayTitle: alarm.displayTitle,
            isEnabled: alarm.isEnabled
        )
    }
    
    func convert(timer: MTTimer?) -> Timer? {
        // state: 3 == running
        guard let timer, timer.state == 3 else { return nil }
        return .init(
            id: timer.timerID,
            url: timer.timerURL,
            fireDate: timer.fireDate
        )
    }
}
