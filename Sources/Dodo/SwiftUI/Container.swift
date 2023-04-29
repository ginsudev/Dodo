//
//  Container.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct Container: View {
    @StateObject private var mediaModel = MediaPlayer.ViewModel.shared
    @StateObject private var dimensions = Dimensions.shared
    @StateObject private var appsManager = AppsManager.shared
    
    var body: some View {
        mainContent
            .background(gradient)
            .environmentObject(dimensions)
            .environmentObject(appsManager)
            .environment(\.isVisibleLockScreen, dimensions.isVisibleLockScreen)
            .readFrame(for: { frame in
                updateFrame(frame)
            })
    }
}

//MARK: - Private

private extension Container {
    @ViewBuilder
    var gradient: some View {
        if !dimensions.isLandscape {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .colorMultiply(Color(mediaModel.artworkColour))
            .animation(.easeInOut, value: mediaModel.artworkColour)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    var mediaPlayer: some View {
        VStack(spacing: 10) {
            divider
            MediaPlayer(style: PreferenceManager.shared.settings.playerStyle)
                .environmentObject(mediaModel)
        }
    }
    
    @ViewBuilder
    var divider: some View {
        if PreferenceManager.shared.settings.showDivider,
           !dimensions.isLandscape,
           (PreferenceManager.shared.settings.showSuggestions || mediaModel.hasActiveMediaApp) {
            Divider()
                .overlay(Color(Colors.dividerColor).opacity(0.5))
        }
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
            AppView()
                .frame(
                    height: 80,
                    alignment: .bottom
                )
        }
    }
    
    var mainContent: some View {
        VStack(
            alignment: .leading,
            spacing: 10.0
        ) {
            if PreferenceManager.shared.settings.hasStatusItems {
                StatusItemGroupView()
            }
            switch PreferenceManager.shared.settings.timeMediaPlayerStyle {
            case .time:
                MainContent()
            case .mediaPlayer:
                favouriteApps
                mediaPlayer
            case .both:
                MainContent()
                mediaPlayer
            }
        }
        .padding(.horizontal, Dimensions.Padding.system)
        .padding(.bottom, UIDevice._hasHomeButton() ? Dimensions.Padding.system : Dimensions.Padding.small)
        .padding(.bottom, dimensions.androBarHeight)
    }
    
    func updateFrame(_ frame: CGRect) {
        DispatchQueue.main.async {
            dimensions.dodoFrame = frame
            NotificationCenter.default.post(
                name: .didUpdateHeight,
                object: nil
            )
        }
    }
}
