//
//  AlarmDataSource.swift
//  
//
//  Created by Noah Little on 7/1/2023.
//

import Foundation

struct Alarm: Identifiable {
    let id: UUID
    let url: URL
    let nextFireDate: Date
    let displayTitle: String
    let isEnabled: Bool
}

final class AlarmDataSource: ObservableObject {
    static let shared = AlarmDataSource()
    
    @Published var nextEnabledAlarm: Alarm?
    
    @Published var alarms = [Alarm]() {
        didSet {
            nextEnabledAlarm = alarms.first(where: \.isEnabled)
        }
    }
}
