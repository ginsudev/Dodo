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
    @StateObject var mediaModel = MediaPlayer.ViewModel.shared
    @StateObject var dimensions = Dimensions.shared

    var body: some View {
        ZStack {
            gradient
            mainContent
                .padding(
                    .bottom,
                    GSUtilities.sharedInstance().isAndroBarInstalled()
                    ? GSUtilities.sharedInstance().androBarHeight
                    : 0
                )
                .environmentObject(dimensions)
        }
        .background(Color.clear)
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
        switch (PreferenceManager.shared.settings.playerStyle,
                mediaModel.hasActiveMediaApp,
                PreferenceManager.shared.settings.showSuggestions
        ) {
        case (_, false, false):
            EmptyView()
                .frame(maxWidth: .zero, maxHeight: .zero)
                .layoutPriority(-1)
        case (.modular, _, _):
            divider
            ModularMediaPlayerContainer()
                .environmentObject(mediaModel)
        case (.classic, true, _):
            divider
            MediaPlayer(artworkRadius: 5.0)
                .environmentObject(mediaModel)
        default:
            divider
            SuggestionView()
        }
    }
    
    @ViewBuilder
    var divider: some View {
        if PreferenceManager.shared.settings.showDivider && !dimensions.isLandscape {
            Divider()
                .overlay(Color(Colors.dividerColor).opacity(0.5))
        }
    }
    
    var mainContent: some View {
        VStack(spacing: 20.0) {
            Spacer()

            switch PreferenceManager.shared.settings.timeMediaPlayerStyle {
            case .time:
                MainContent()
            case .mediaPlayer:
                Spacer()
                mediaPlayer
            case .both:
                MainContent()
                mediaPlayer
            }
        }
        .padding(.horizontal)
    }
}
