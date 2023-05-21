//
//  UserDefaults+Extensions.swift
//  
//
//  Created by Noah Little on 14/5/2023.
//

import Foundation

extension UserDefaults {
    func timer(forKey key: String) -> AlarmTimerManager.Timer? {
        guard let timerData = value(forKey: key) as? Data,
              let timer = try? JSONDecoder().decode(AlarmTimerManager.Timer.self, from: timerData)
        else { return nil }
        return timer
    }
    
    func alarm(forKey key: String) -> AlarmTimerManager.Alarm? {
        guard let alarmData = value(forKey: key) as? Data,
              let alarm = try? JSONDecoder().decode(AlarmTimerManager.Alarm.self, from: alarmData)
        else { return nil }
        return alarm
    }
    
    func set(timer: AlarmTimerManager.Timer?, forKey key: String) {
        let data = try? JSONEncoder().encode(timer)
        setValue(data, forKey: key)
    }
    
    func set(alarm: AlarmTimerManager.Alarm?, forKey key: String) {
        let data = try? JSONEncoder().encode(alarm)
        setValue(data, forKey: key)
    }
}
