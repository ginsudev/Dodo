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
        var gridItem: GridItem
        switch Dimensions.shared.favouriteAppsGridSizeType {
        case .flexible:
            gridItem = GridItem(
                .flexible(
                    minimum: 10,
                    maximum: Dimensions.shared.favouriteAppsGridItemSize
                ),
                spacing: 5,
                alignment: .trailing
            )
        case .fixed:
            gridItem = GridItem(
                .fixed(Dimensions.shared.favouriteAppsGridItemSize),
                spacing: 5,
                alignment: .trailing
            )
        }
        return [GridItem](
            repeating: gridItem,
            count: Dimensions.shared.favouriteAppsGridColumnAmount
        )
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
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
        .mask(mask)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Private

private extension AppView {
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
