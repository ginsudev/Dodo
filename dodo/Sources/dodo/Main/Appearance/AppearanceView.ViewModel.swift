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
            case .time: return Copy.time
            case .mediaPlayer: return Copy.mediaPlayer
            case .both: return Copy.bothTimeAndMediaPlayer
            }
        }
    }
    
    enum DateTemplate: Int, CaseIterable {
        case `default`
        case custom
        
        var title: String {
            switch self {
            case .default: return Copy.default
            case .custom: return Copy.custom
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
            case .default: return Copy.default
            case .monospaced: return Copy.monospaced
            case .rounded: return Copy.rounded
            case .serif: return Copy.serif
            }
        }
    }
}
