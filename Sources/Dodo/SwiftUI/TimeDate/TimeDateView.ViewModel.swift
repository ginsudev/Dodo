//
//  TimeDateView.ViewModel.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import Foundation

extension TimeDateView {
    final class ViewModel: ObservableObject {
        static let shared = ViewModel()
        
        @Published var time = ""
        @Published var date = ""
        
        private func string(fromTemplate template: DateTemplate) -> String {
            switch template {
            case .timeWithSeconds:
                return PreferenceManager.shared.settings.is24HourModeEnabled ? "H:mm:ss" : "h:mm:ss"
            case .time:
                return PreferenceManager.shared.settings.is24HourModeEnabled ? "H:mm" : "h:mm"
            case .timeCustom(let timeCustom):
                return timeCustom
            case .date:
                return "EEEE, MMMM d"
            case .dateCustom(let dateCustom):
                return dateCustom
            }
        }
        
        func getDate(fromTemplate template: DateTemplate) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = string(fromTemplate: template)
            return formatter.string(from: Date())
        }
        
        func update(timeTemplate time: DateTemplate, dateTemplate date: DateTemplate) {
            self.time = getDate(fromTemplate: time)
            self.date = getDate(fromTemplate: date)
        }
    }
}
