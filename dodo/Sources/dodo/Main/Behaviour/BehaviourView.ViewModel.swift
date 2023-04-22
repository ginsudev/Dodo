//
//  BehaviourView.ViewModel.swift
//  
//
//  Created by Noah Little on 4/4/2023.
//

import Foundation

extension BehaviourView {
    enum TimeTemplate: Int, CaseIterable {
        case `default`
        case showSeconds
        case custom
        
        var title: String {
            switch self {
            case .default: return "Default"
            case .showSeconds: return "Show seconds"
            case .custom: return "Custom"
            }
        }
        
        var format: String? {
            switch self {
            case .default: return "h:mm"
            case .showSeconds: return "h:mm:ss"
            case .custom: return nil
            }
        }
    }
    
    enum DateTemplate: Int, CaseIterable {
        case `default`
        case custom
        
        var title: String {
            switch self {
            case .default: return "Default"
            case .custom: return "Custom"
            }
        }
        
        var format: String? {
            switch self {
            case .default: return "EEEE, MMMM d"
            case .custom: return nil
            }
        }
    }
    
    struct ViewModel {
        func formattedDate(format: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: Date())
        }
    }
}
