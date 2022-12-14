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
    private let artworkRadius: Double
    
    init(artworkRadius: Double) {
        self.artworkRadius = artworkRadius
    }

    var body: some View {
        HStack {
            songDetailsButton
                .layoutPriority(-1)
            Spacer()
            MediaControls()
        }
    }
}

//MARK: - Private

private extension MediaPlayer {
    var songDetailsButton: some View {
        Button {
            guard let nowPlayingIdentifier = mediaModel.nowPlayingAppIdentifier() else {
                return
            }
            AppsManager.openApplication(withIdentifier: nowPlayingIdentifier)
        } label: {
            HStack {
                albumArtwork
                trackDetails
            }
        }
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
