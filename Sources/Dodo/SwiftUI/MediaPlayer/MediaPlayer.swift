//
//  MediaPlayer.swift
//  
//
//  Created by Noah Little on 20/11/2022.
//

import SwiftUI

//MARK: Public

struct MediaPlayer: View {
    @EnvironmentObject var mediaModel: ViewModel
    @EnvironmentObject var dimensions: Dimensions
    
    private let artworkRadius: Double
    
    init(artworkRadius: Double) {
        self.artworkRadius = artworkRadius
    }

    var body: some View {
        if dimensions.isLandscape {
            landscapePlayer
        } else {
            portraitPlayer
        }
    }
}

//MARK: - Private

private extension MediaPlayer {
    var landscapePlayer: some View {
        HStack(spacing: 10.0) {
            songDetailsButton
            MediaControls()
        }
    }
    
    var portraitPlayer: some View {
        HStack {
            songDetailsButton
            Spacer()
            MediaControls()
        }
    }
    
    @ViewBuilder
    var songDetailsButton: some View {
        Button {
            if let nowPlayingIdentifier = mediaModel.nowPlayingAppIdentifier() {
                AppsManager.openApplication(withIdentifier: nowPlayingIdentifier)
            }
        } label: {
            HStack {
                albumArtwork
                if !dimensions.isLandscape {
                    trackDetails
                }
            }
        }
        .layoutPriority(-1)
    }
    
    var albumArtwork: some View {
        Image(uiImage: mediaModel.albumArtwork)
            .resizable()
            .frame(maxWidth: 45, maxHeight: 45)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(artworkRadius)
            .shadow(color: .black.opacity(0.4), radius: artworkRadius)
    }
    
    var trackDetails: some View {
        VStack(alignment: .leading) {
            Text(mediaModel.trackName)
                .font(.system(size: 15, weight: .regular, design: PreferenceManager.shared.settings.fontType))
            Text(mediaModel.artistName)
                .font(.system(size: 12, weight: .regular, design: PreferenceManager.shared.settings.fontType))
        }
        .foregroundColor(Color(mediaModel.foregroundColour))
        .lineLimit(1)
    }
}
