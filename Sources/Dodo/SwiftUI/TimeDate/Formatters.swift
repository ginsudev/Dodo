//
//  Formatters.swift
//  
//
//  Created by Noah Little on 27/4/2023.
//

import Foundation

struct Formatters {
    static let time = createFormatter(format: "h:mm".twentyFourHourized)
    
    static let timeWithSeconds = createFormatter(format: "h:mm:ss".twentyFourHourized)
    
    static let seconds = createFormatter(format: "ss")
    
    static let date = createFormatter(format: "EEEE, MMMM d")
    
    static let customTimeFormatter: DateFormatter? = {
        if case let .timeCustom(format) = PreferenceManager.shared.settings.timeDate.timeTemplate {
            return createFormatter(format: format)
        } else {
            return nil
        }
    }()
    
    static let customDateFormatter: DateFormatter? = {
        if case let .dateCustom(format) = PreferenceManager.shared.settings.timeDate.dateTemplate {
            return createFormatter(format: format)
        } else {
            return nil
        }
    }()
    
    static func formatter(template: DateTemplate) -> DateFormatter? {
        switch template {
        case .timeWithSeconds:
            return timeWithSeconds
        case .time:
            return time
        case .timeCustom:
            return customTimeFormatter
        case .date:
            return date
        case .dateCustom:
            return customDateFormatter
        case .seconds:
            return seconds
        }
    }
    
    private static func createFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
}

extension String {
    var twentyFourHourized: Self {
        if PreferenceManager.shared.settings.timeDate.isEnabled24HourMode {
            return replacingOccurrences(of: "h:", with: "HH:")
        } else { return self }
    }
}
