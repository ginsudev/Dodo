//
//  AlarmTimerManager+Types.swift
//  
//
//  Created by Noah Little on 15/5/2023.
//

import Foundation

extension AlarmTimerManager {
    struct Alarm: Identifiable, Codable {
        let id: UUID
        let url: URL
        let nextFireDate: Date
        let displayTitle: String
        let isEnabled: Bool
    }
    
    struct Timer: Identifiable, Codable {
        let id: UUID
        let url: URL
        let fireDate: Date
    }
}
