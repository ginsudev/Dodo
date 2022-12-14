//
//  ModularMediaPlayerContainer.swift
//  
//
//  Created by Noah Little on 21/11/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct ModularMediaPlayerContainer: View {
    @EnvironmentObject var mediaModel: MediaPlayer.ViewModel
    @State private var scale = 1.0

    var body: some View {
        if PreferenceManager.shared.settings.hasModularBounceEffect {
            contentView
                .scaleEffect(scale)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: scale)
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged { _ in
                            scale = 0.8
                        }
                        .onEnded { _ in
                            scale = 1.0
                        }
                )
        } else {
            contentView
        }
    }
}

//MARK: - Private

private extension ModularMediaPlayerContainer {
    var containerView: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .colorMultiply(
                mediaModel.hasActiveMediaApp
                ? Color(mediaModel.artworkColour)
                : Color(UIImage(withBundleIdentifier: AppsManager.suggestedAppBundleIdentifier).dominantColour())
            )
            .animation(.easeInOut, value: mediaModel.artworkColour)
    }
    
    var contentView: some View {
        Group {
            if mediaModel.hasActiveMediaApp {
                MediaPlayer(artworkRadius: 5)
            } else {
                SuggestionView()
            }
        }
        .padding()
        .background (
            containerView
        )
    }
}

