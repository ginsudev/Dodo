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

final class AlarmTimerDataSource: ObservableObject {
    static let shared = AlarmTimerDataSource()
    
    @Published var nextEnabledAlarm: DDAlarm?
    
    @Published var alarms = [DDAlarm]() {
        didSet {
            nextEnabledAlarm = alarms.first(where: \.isEnabled)
        }
    }
}
