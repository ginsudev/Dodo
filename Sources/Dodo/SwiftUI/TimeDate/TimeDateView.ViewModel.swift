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
                return "h:mm:ss"
            case .time:
                return "h:mm"
            case .timeCustom(let custom):
                return custom
            case .date:
                return "EEEE, MMMM d"
            case .dateCustom(let custom):
                return custom
            }
        }
        
        func getDate(fromTemplate template: DateTemplate) -> String {
            let formatter = DateFormatter()
            let localisedDateFormat = DateFormatter.dateFormat(
                fromTemplate: string(fromTemplate: template),
                options: 0,
                locale: Locale.current
            )
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = localisedDateFormat
            return formatter.string(from: Date())
        }
        
        func update(timeTemplate time: DateTemplate, dateTemplate date: DateTemplate) {
            self.time = getDate(fromTemplate: time)
            self.date = getDate(fromTemplate: date)
        }
    }
}
