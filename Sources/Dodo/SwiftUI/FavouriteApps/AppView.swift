//
//  AppView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct AppView: View {
    @StateObject private var appsManager = AppsManager.shared
    
    private var installedApplications: [String] {
        appsManager.favouriteAppBundleIdentifiers.filter({
            appsManager.isInstalled(app: .custom($0))
        })
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if case .adaptive = Dimensions.shared.favouriteAppsGridSizeType {
                gridView
                    // For some reason we need this in adaptive mode. Otherwise the apps will be on the leading edge.
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
    @ViewBuilder
    var gridView: some View {
        LazyVGrid(columns: columns, alignment: .trailing) {
            ForEach(installedApplications, id: \.self) { identifier in
                if let image = UIImage.image(forBundleIdentifier: identifier) {
                    Button {
                        appsManager.open(app: .custom(identifier))
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
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
    
    var columns: [GridItem] {
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
}
