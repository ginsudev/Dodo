//
//  MainContent.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct MainContent: View {
    @EnvironmentObject var dimensions: Dimensions
    @State private var timeFrame: CGRect = .zero
    @State private var appViewHeight: CGFloat = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            StatusItemGroupView()
                .frame(maxHeight: 18)
            midSection
        }
    }
}

private extension MainContent {
    @ViewBuilder
    var midSection: some View {
        HStack(spacing: 15) {
            TimeDateView()
                .readFrame(for: $timeFrame)
                .onChange(of: timeFrame) { newFrame in
                    appViewHeight = newFrame.height
                }
            Spacer()
            favouriteApps
        }
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
            AppView()
                .frame(maxHeight: appViewHeight)
                .clipped()
                .layoutPriority(-1)
        }
    }
}
