//
//  AppearanceView.ViewModel.swift
//  
//
//  Created by Noah Little on 4/4/2023.
//

import Foundation

extension AppearanceView {
    enum TimeMediaPlayerStyle: Int, CaseIterable {
        case time
        case mediaPlayer
        case both
        
        var title: String {
            switch self {
            case .time: return "Time"
            case .mediaPlayer: return "Media player"
            case .both: return "Both"
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
    
    enum FontType: Int, CaseIterable {
        case `default`
        case monospaced
        case rounded
        case serif
        
        var title: String {
            switch self {
            case .default: return "Default"
            case .monospaced: return "Monospaced"
            case .rounded: return "Rounded"
            case .serif: return "Serif"
            }
        }
    }
}
