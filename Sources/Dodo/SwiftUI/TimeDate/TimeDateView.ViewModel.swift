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
    case seconds
}

extension TimeDateView {
    final class ViewModel: ObservableObject {
        static let shared = ViewModel()
        private let dateFormatter = DateFormatter()

        @Published var time = ""
        @Published var date = ""
        @Published var seconds = ""

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
            case .seconds:
                return "ss"
            }
        }
        
        func getDate(fromTemplate template: DateTemplate, date: Date? = nil) -> String {
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = string(fromTemplate: template)
            return dateFormatter.string(from: date ?? Date())
        }
        
        func update(timeTemplate time: DateTemplate, dateTemplate date: DateTemplate) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.time = self.getDate(fromTemplate: time)
                self.date = self.getDate(fromTemplate: date)
                self.seconds = self.getDate(fromTemplate: .seconds)
            }
        }
    }
}
