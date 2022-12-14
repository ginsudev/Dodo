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
        }
        .background(Color.clear)
    }
}

//MARK: - Private

private extension Container {
    var gradient: some View {
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
    
    @ViewBuilder
    var mediaPlayer: some View {
        if PreferenceManager.shared.settings.showDivider {
            Divider()
                .overlay(Color(Colors.dividerColor).opacity(0.5))
        }
        
        if PreferenceManager.shared.settings.playerStyle == .modular {
            ModularMediaPlayerContainer()
                .environmentObject(mediaModel)
        } else if PreferenceManager.shared.settings.playerStyle == .classic && mediaModel.hasActiveMediaApp {
            MediaPlayer(artworkRadius: 5.0)
                .environmentObject(mediaModel)
        } else if PreferenceManager.shared.settings.playerStyle == .classic && !mediaModel.hasActiveMediaApp{
            SuggestionView()
        }
    }
    
    var mainContent: some View {
        VStack(spacing: 20.0) {
            if PreferenceManager.shared.settings.timeMediaPlayerStyle == .both {
                MainContent()
                mediaPlayer
                    .frame(alignment: .bottom)
            } else if PreferenceManager.shared.settings.timeMediaPlayerStyle == .time {
                Spacer()
                MainContent()
            } else {
                Spacer()
                mediaPlayer
            }
        }
        .padding(.horizontal)
    }
}
