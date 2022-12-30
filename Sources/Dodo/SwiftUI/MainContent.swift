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
    @State private var infoViewFrame: CGRect = .zero
    
    var body: some View {
        HStack(spacing: 0) {
            infoView
            favouriteApps
        }
    }
}

private extension MainContent {
    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            StatusItemGroupView()
                .frame(maxHeight: 18)
            TimeDateView()
        }
        .layoutPriority(1)
        .readFrame(for: $infoViewFrame)
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
            Spacer()
            AppView()
                .layoutPriority(-1)
                .frame(minWidth: 130, maxHeight: infoViewFrame.height, alignment: .trailing)
                .fixedSize(horizontal: true, vertical: true)
        }
    }
}
