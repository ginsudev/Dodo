//
//  TimeDateView.ViewModel.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import Foundation

enum DateTemplate {
    case timeWithSeconds
    case time
    case timeCustom(String)
    case date
    case dateCustom(String)
}

extension TimeDateView {
    final class ViewModel: ObservableObject {
        static let shared = ViewModel()
        
        @Published var time = ""
        @Published var date = ""
        
        private func string(fromTemplate template: DateTemplate) -> String {
            switch template {
            case .timeWithSeconds:
                return PreferenceManager.shared.settings.is24HourModeEnabled ? "HH:mm:ss" : "h:mm:ss"
            case .time:
                return PreferenceManager.shared.settings.is24HourModeEnabled ? "HH:mm" : "h:mm"
            case .timeCustom(let timeCustom):
                return timeCustom
            case .date:
                return "EEEE, MMMM d"
            case .dateCustom(let dateCustom):
                return dateCustom
            }
        }
        
        func getDate(fromTemplate template: DateTemplate, date: Date? = nil) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = string(fromTemplate: template)
            return formatter.string(from: date ?? Date())
        }
        
        func update(timeTemplate time: DateTemplate, dateTemplate date: DateTemplate) {
            self.time = getDate(fromTemplate: time)
            self.date = getDate(fromTemplate: date)
        }
    }
}
