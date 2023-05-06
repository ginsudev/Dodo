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
            case .flexible: return Copy.flexible
            case .fixed: return Copy.fixed
            case .adaptive: return Copy.adaptive
            }
        }
    }
}
