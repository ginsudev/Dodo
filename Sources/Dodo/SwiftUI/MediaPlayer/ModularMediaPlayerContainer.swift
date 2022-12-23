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

    var body: some View {
        contentView
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
                if PreferenceManager.shared.settings.showSuggestions {
                    SuggestionView()
                }
            }
        }
        .padding()
        .background (
            containerView
        )
    }
}

