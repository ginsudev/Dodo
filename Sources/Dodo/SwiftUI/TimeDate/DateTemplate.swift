//
//  TimeDateView.ViewModel.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import Foundation

enum DateTemplate: Equatable {
    case timeWithSeconds
    case time
    case timeCustom(String)
    case date
    case dateCustom(String)
    case seconds
    
    var id: Self { self }
    
    func dateString(date: Date? = nil) -> String? {
        guard let formatter = Formatters.formatter(template: self) else { return nil }
        formatter.locale = .current
        return formatter.string(from: date ?? Date())
    }
}
