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
        .ignoresSafeArea()
        .colorMultiply(Color(mediaModel.artworkColour))
        .animation(.easeInOut, value: mediaModel.artworkColour)
    }
    
    var mediaPlayer: some View {
        Group {
            if Settings.showDivider {
                Divider()
                    .overlay(Color(Colors.dividerColor).opacity(0.5))
            }
            
            if Settings.playerStyle == .modular {
                ModularMediaPlayerContainer()
                    .environmentObject(mediaModel)
            } else if Settings.playerStyle == .classic && mediaModel.hasActiveMediaApp {
                MediaPlayer(artworkRadius: 5.0)
                    .environmentObject(mediaModel)
            } else if Settings.playerStyle == .classic && !mediaModel.hasActiveMediaApp{
                SuggestionView()
            }
        }
    }
    
    var mainContent: some View {
        Group {
            VStack(spacing: 20.0) {
                if Settings.timeMediaPlayerStyle == .both {
                    MainContent()
                    mediaPlayer
                        .frame(alignment: .bottom)
                } else if Settings.timeMediaPlayerStyle == .time {
                    Spacer()
                    MainContent()
                } else {
                    Spacer()
                    mediaPlayer
                }
            }
        }
        .padding(.horizontal)
    }
}
