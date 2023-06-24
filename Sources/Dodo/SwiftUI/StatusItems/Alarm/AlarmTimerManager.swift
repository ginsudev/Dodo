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
    
    private var bag: Set<AnyCancellable> = []
    
    @Published
    private(set) var nextTimer: Timer? = PreferenceManager.shared.defaults.timer(forKey: Keys.nextTimer)
    
    @Published
    private(set) var nextAlarm: Alarm? = PreferenceManager.shared.defaults.alarm(forKey: Keys.nextAlarm)
    
    init() {
        subscribe()
    }
}

// MARK: - Private

private extension AlarmTimerManager {
    func subscribe() {
        NotificationCenter.default.publisher(for: .didChangeNextAlarm)
            .receive(on: DispatchQueue.main)
            .map { $0.userInfo?[Self.nextAlarmKey] as? MTAlarm }
            .map { [weak self] in self?.convert(alarm: $0) }
            .assign(to: &$nextAlarm)
        
        NotificationCenter.default.publisher(for: .didChangeNextTimer)
            .receive(on: DispatchQueue.main)
            .map { $0.userInfo?[Self.nextTimerKey] as? MTTimer }
            .map { [weak self] in self?.convert(timer: $0) }
            .assign(to: &$nextTimer)
        
        $nextAlarm
            .sink {
                PreferenceManager.shared.defaults.set(alarm: $0, forKey: Keys.nextAlarm)
            }
            .store(in: &bag)
        
        $nextTimer
            .sink {
                PreferenceManager.shared.defaults.set(timer: $0, forKey: Keys.nextTimer)
            }
            .store(in: &bag)
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
