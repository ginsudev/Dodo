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
                .padding(.bottom, UIDevice._hasHomeButton() ? 12 : 0)
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
        VStack(spacing: 10) {
            divider
            MediaPlayer(style: PreferenceManager.shared.settings.playerStyle)
                .environmentObject(mediaModel)
        }
    }
    
    @ViewBuilder
    var divider: some View {
        if PreferenceManager.shared.settings.showDivider && !dimensions.isLandscape {
            Divider()
                .overlay(Color(Colors.dividerColor).opacity(0.5))
        }
    }
    
    @ViewBuilder
    var favouriteApps: some View {
        if PreferenceManager.shared.settings.hasFavouriteApps, !dimensions.isLandscape {
            AppView()
                .frame(height: 80, alignment: .bottom)
        }
    }
    
    var mainContent: some View {
        VStack(alignment: .leading, spacing: 10.0) {
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
        .frame(alignment: .bottom)
        .padding(.horizontal)
        .readFrame(in: .local, for: $containerFrame)
        .onChange(of: containerFrame) { newFrame in
            dimensions.height = newFrame.height + 10
        }
    }
}
