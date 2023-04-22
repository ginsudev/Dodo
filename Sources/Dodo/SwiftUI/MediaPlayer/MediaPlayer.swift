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
    private let style: Settings.MediaPlayerStyle
    
    init(style: Settings.MediaPlayerStyle) {
        self.style = style
    }

    var body: some View {
        switch style {
        case .modular:
            playerView
                .padding(Dimensions.Padding.medium)
                .background(modularBackground)
        case .classic:
            playerView
        }
    }
}

//MARK: - Private

private extension MediaPlayer {
    var playerView: some View {
        Group {
            switch (mediaModel.hasActiveMediaApp,
                    PreferenceManager.shared.settings.showSuggestions
            ) {
            case (false, false):
                EmptyView()
            case (true, _):
                HStack {
                    songDetailsButton
                    Spacer()
                    MediaControls()
                }
            default:
                SuggestionView()
            }
        }
        // Take up all the space we need in portrait, only take up what we need in landscape.
        .fixedSize(
            horizontal: dimensions.isLandscape,
            vertical: true
        )
    }
    
    var modularBackground: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(
                Color.white,
                strokeBorder: Color.secondary.opacity(0.3),
                lineWidth: 0.4
            )
            .colorMultiply(Color(mediaModel.modularBackgroundColorMultiply))
            .animation(
                .easeInOut,
                value: mediaModel.artworkColour
            )
    }
    
    @ViewBuilder
    var songDetailsButton: some View {
        Button {
            mediaModel.openNowPlayingApp()
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
    
    @ViewBuilder
    var albumArtwork: some View {
        if let image = mediaModel.albumArtwork {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    maxWidth: 45,
                    maxHeight: 45
                )
                .cornerRadius(style.artworkRadius)
                .shadow(
                    color: .black.opacity(0.4),
                    radius: style.artworkRadius
                )
        }
    }
    
    @ViewBuilder
    var trackDetails: some View {
        if PreferenceManager.shared.settings.isMarqueeLabels {
            VStack(alignment: .leading, spacing: 0.0) {
                MarqueeText(
                    text: mediaModel.trackName,
                    color: .white,
                    font: .systemFont(ofSize: 15),
                    rate: 50,
                    fadeLength: 10.0,
                    isScrollable: dimensions.isVisibleLockScreen
                )
                MarqueeText(
                    text: mediaModel.artistName,
                    color: .white,
                    font: .systemFont(ofSize: 12),
                    rate: 60,
                    fadeLength: 20.0,
                    isScrollable: dimensions.isVisibleLockScreen
                )
            }
        } else {
            VStack(alignment: .leading) {
                Text(mediaModel.trackName)
                    .font(
                        .system(
                            size: 15.0,
                            design: PreferenceManager.shared.settings.selectedFont.representedFont
                        )
                    )
                Text(mediaModel.artistName)
                    .font(
                        .system(
                            size: 12.0,
                            design: PreferenceManager.shared.settings.selectedFont.representedFont
                        )
                    )
            }
            .foregroundColor(Color(mediaModel.foregroundColour))
            .lineLimit(1)
        }
    }
}
