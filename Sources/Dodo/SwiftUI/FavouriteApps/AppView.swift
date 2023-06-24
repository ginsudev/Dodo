//
//  AppView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI
import DodoC
import GSCore

//MARK: - Public

struct AppView: View {
    @EnvironmentObject
    private var appsManager: AppsManager
    
    private let settings = PreferenceManager.shared.settings.favouriteApps

    private var installedApplications: [String] {
        settings.favouriteAppBundleIdentifiers.filter {
            appsManager.isInstalled(app: .custom($0))
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if case .adaptive = settings.favouriteAppsGridSizeType {
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
        LazyVGrid(
            columns: columns,
            alignment: .trailing
        ) {
            ForEach(installedApplications, id: \.self) { identifier in
                if let image = UIImage.icon(bundleIdentifier: identifier) {
                    Button {
                        appsManager.open(app: .custom(identifier))
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var mask: some View {
        VStack(spacing: 0) {
            Color.black
            if settings.isVisibleFavouriteAppsFade {
                LinearGradient(gradient: Gradient(
                    colors: [.black, .black.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 15)
            }
        }
    }
    
    var columns: [GridItem] {
        switch settings.favouriteAppsGridSizeType {
        case .flexible:
            return [GridItem](
                repeating: GridItem(
                    .flexible(
                        minimum: 0,
                        maximum: settings.favouriteAppsFlexibleGridItemSize
                    ),
                    alignment: .trailing
                ),
                count: settings.favouriteAppsFlexibleGridColumnAmount
            )
        case .fixed:
            return [GridItem](
                repeating: GridItem(
                    .fixed(settings.favouriteAppsFixedGridItemSize),
                    alignment: .trailing
                ),
                count: settings.favouriteAppsFixedGridColumnAmount
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
