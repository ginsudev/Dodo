//
//  AppView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct AppView: View {
    
    private var columns: [GridItem] {
        switch Dimensions.shared.favouriteAppsGridSizeType {
        case .flexible:
            return [GridItem](
                repeating: GridItem(
                    .flexible(
                        minimum: 10,
                        maximum: Dimensions.shared.favouriteAppsFlexibleGridItemSize
                    ),
                    alignment: .trailing
                ),
                count: Dimensions.shared.favouriteAppsFlexibleGridColumnAmount
            )
        case .fixed:
            return [GridItem](
                repeating: GridItem(
                    .fixed(Dimensions.shared.favouriteAppsFixedGridItemSize),
                    alignment: .trailing
                ),
                count: Dimensions.shared.favouriteAppsFixedGridColumnAmount
            )
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if gridAlignment == .trailing {
                gridView
                    .environment(\.layoutDirection, .rightToLeft)
            } else {
                gridView
            }
        }
        .mask(mask)
    }
}

// MARK: - Private

private extension AppView {
    var gridView: some View {
        LazyVGrid(columns: columns, alignment: gridAlignment) {
            ForEach(AppsManager.favouriteAppBundleIdentifiers, id: \.self) { identifier in
                Button {
                    AppsManager.openApplication(withIdentifier: identifier)
                } label: {
                    Image(uiImage: UIImage(withBundleIdentifier: identifier))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
    
    @ViewBuilder
    var mask: some View {
        VStack(spacing: 0) {
            Color.black
            if PreferenceManager.shared.settings.isVisibleFavouriteAppsFade {
                LinearGradient(gradient: Gradient(
                    colors: [.black,.black.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 15)
            }
        }
    }
    
    var gridAlignment: HorizontalAlignment {
        if PreferenceManager.shared.settings.timeMediaPlayerStyle == .mediaPlayer {
            return .center
        }
        return .trailing
    }
}
