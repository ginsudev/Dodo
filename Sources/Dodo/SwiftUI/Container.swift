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
    @State private var containerFrame: CGRect = .zero

    var body: some View {
        ZStack(alignment: .bottom) {
            gradient
            mainContent
                .padding(.bottom)
                .padding(.bottom, dimensions.androBarHeight)
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
        VStack(alignment: .leading, spacing: 20.0) {
            switch PreferenceManager.shared.settings.timeMediaPlayerStyle {
            case .time:
                MainContent()
            case .mediaPlayer:
                mediaPlayer
            case .both:
                MainContent()
                mediaPlayer
            }
        }
        .frame(alignment: .bottom)
        .padding(.horizontal)
        .readFrame(in: .local, for: $containerFrame)
        .onChange(of: containerFrame) { newFrame in
            dimensions.height = newFrame.height + 30
        }
    }
}
