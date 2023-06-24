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
    @StateObject
    private var mediaModel = MediaPlayer.ViewModel()
    
    @StateObject
    private var localState = LocalState.shared
    
    @StateObject
    private var appsManager = AppsManager.shared
    
    @State
    private var isVisibleLockScreen = true
    
    private let settings = PreferenceManager.shared.settings

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            mainContent
                .environmentObject(appsManager)
        }
        .background(Color.clear)
        .readFrame(for: { frame in
            updateFrame(frame)
        })
        .environment(\.isVisibleLockScreen, !localState.isScreenOff && isVisibleLockScreen)
        .environment(\.isLandscape, localState.isLandscape)
        .onAppear {
            isVisibleLockScreen = true
        }
        .onDisappear {
            isVisibleLockScreen = false
        }
        .onReceive(
            condition: settings.appearance.hasChargingFlash,
            publisher: NotificationCenter.default.publisher(for: .refreshOnceContent)
        ) { [weak mediaModel] _ in
            mediaModel?.activateChargeIndication()
        }
    }
}

// MARK: - Private

private extension Container {
    @ViewBuilder
    var gradient: some View {
        if !localState.isLandscape {
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
            MediaPlayer(
                viewModel: mediaModel,
                style: settings.mediaPlayer.playerStyle
            )
        }
    }
    
    @ViewBuilder
    var divider: some View {
        if settings.mediaPlayer.showDivider,
           !localState.isLandscape,
           (settings.mediaPlayer.showSuggestions || mediaModel.hasActiveMediaApp) {
            Divider()
                .overlay(Color(settings.colors.dividerColor).opacity(0.5))
        }
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if settings.favouriteApps.hasFavouriteApps, !localState.isLandscape {
            AppView()
                .frame(height: 80, alignment: .bottom)
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
            switch settings.mediaPlayer.timeMediaPlayerStyle {
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
        .padding(.horizontal, Padding.system)
        .padding(.bottom, UIDevice._hasHomeButton() ? Padding.system : Padding.small)
        .padding(.bottom, settings.dimensions.androBarHeight)
    }
    
    func updateFrame(_ frame: CGRect) {
        DispatchQueue.main.async {
            localState.dodoFrame = frame
            NotificationCenter.default.post(
                name: .didUpdateHeight,
                object: nil
            )
        }
    }
}
