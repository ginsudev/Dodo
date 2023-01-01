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
                        minimum: 0,
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
        case .adaptive:
            return [GridItem(
                .adaptive(
                    minimum: 25,
                    maximum: 50
                ),
                alignment: .trailing)
            ]
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            gridView
        }
        .fixedSize(horizontal: true, vertical: false)
        .mask(mask)
    }
}

// MARK: - Private

private extension AppView {
    var gridView: some View {
        LazyVGrid(columns: columns, alignment: .trailing) {
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
}
