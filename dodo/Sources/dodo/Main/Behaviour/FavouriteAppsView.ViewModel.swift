//
//  FavouriteAppsView.ViewModel.swift
//  
//
//  Created by Noah Little on 22/4/2023.
//

import Foundation

extension FavouriteAppsView {
    enum GridSizeType: Int, CaseIterable {
        case flexible
        case fixed
        case adaptive
        
        var title: String {
            switch self {
            case .flexible: return "Flexible"
            case .fixed: return "Fixed"
            case .adaptive: return "Adaptive"
            }
        }
    }
    
    struct ViewModel {
        
    }
}
