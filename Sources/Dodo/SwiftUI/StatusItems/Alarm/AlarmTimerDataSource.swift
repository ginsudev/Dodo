//
//  AlarmTimerDataSource.swift
//  
//
//  Created by Noah Little on 7/1/2023.
//

import Foundation
import CoreGraphics
import DodoC

struct DDAlarm: Identifiable {
    let id: UUID
    let url: URL
    let nextFireDate: Date
    let displayTitle: String
    let isEnabled: Bool
}

struct DDTimer: Identifiable {
    let id: UUID
    let fireDate: Date
    let remainingTime: CGFloat
    
    var remainingTimeDate: Date {
        fireDate.addingTimeInterval(-remainingTime)
    }
}

final class AlarmTimerDataSource: ObservableObject {
    static let shared = AlarmTimerDataSource()
    
//    weak var timerCache: MTTimerCache?
    
    @Published var nextEnabledAlarm: DDAlarm?
    // @Published var nextTimer: DDTimer?
    
    @Published var alarms = [DDAlarm]() {
        didSet {
            nextEnabledAlarm = alarms.first(where: \.isEnabled)
        }
    }
}
