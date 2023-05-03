//
//  Container.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI
import DodoC

// MARK: - Public

struct Container: View {
    @StateObject private var mediaModel = MediaPlayer.ViewModel()
    @StateObject private var globalState = GlobalState.shared
    @StateObject private var appsManager = AppsManager.shared
    
    private let settings = PreferenceManager.shared.settings
    
    var body: some View {
        ZStack {
            gradient
            mainContent
                .environment(\.isVisibleLockScreen, globalState.isVisibleLockScreen)
                .environment(\.isLandscape, globalState.isLandscape)
                .environmentObject(appsManager)
                .readFrame(for: { frame in
                    updateFrame(frame)
                })
        }
    }
}

// MARK: - Private

private extension Container {
    @ViewBuilder
    var gradient: some View {
        if !globalState.isLandscape {
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
        if let mediaPlayer = settings?.mediaPlayer {
            VStack(spacing: 10) {
                divider
                MediaPlayer(
                    viewModel: mediaModel,
                    style: mediaPlayer.playerStyle
                )
            }
        }
    }
    
    @ViewBuilder
    var divider: some View {
        if let mediaPlayer = settings?.mediaPlayer,
           mediaPlayer.showDivider,
           !globalState.isLandscape,
           (mediaPlayer.showSuggestions || mediaModel.hasActiveMediaApp) {
            Divider()
                .overlay(Color(Colors.dividerColor).opacity(0.5))
        }
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if let favouriteApps = settings?.favouriteApps,
           favouriteApps.hasFavouriteApps,
           !globalState.isLandscape {
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
            if settings.statusItems.hasStatusItems {
                StatusItemGroupView()
            }
            
            if let mediaPlayer = settings?.mediaPlayer {
                switch mediaPlayer.timeMediaPlayerStyle {
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
        }
        .padding(.horizontal, Padding.system)
        .padding(.bottom, UIDevice._hasHomeButton() ? Padding.system : Padding.small)
        .padding(.bottom, settings.dimensions.androBarHeight)
    }
    
    func updateFrame(_ frame: CGRect) {
        DispatchQueue.main.async {
            globalState.dodoFrame = frame
            NotificationCenter.default.post(
                name: .didUpdateHeight,
                object: nil
            )
        }
    }
}
