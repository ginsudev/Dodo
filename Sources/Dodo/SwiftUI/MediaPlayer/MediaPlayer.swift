//
//  MediaPlayer.swift
//  
//
//  Created by Noah Little on 20/11/2022.
//

import SwiftUI

//MARK: Public

struct MediaPlayer: View {
    @Environment(\.isVisibleLockScreen)
    var isVisibleLockScreen
    
    @Environment(\.isLandscape)
    var isLandscape
    
    @ObservedObject
    var viewModel: ViewModel
    
    let style: Settings.MediaPlayerStyle

    var body: some View {
        switch style {
        case .modular:
            playerView
                .padding(Padding.medium)
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
            if viewModel.hasActiveMediaApp {
                HStack {
                    songDetailsButton
                    Spacer()
                    MediaControlsView(
                        visibleControls: viewModel.isPlaying
                        ? MediaControlsView.MediaControl.isPlayingControls
                        : MediaControlsView.MediaControl.isPausedControls
                    ) { [weak viewModel] control in
                        viewModel?.onDidTapMediaControl(control)
                    }
                    .foregroundColor(Color(viewModel.foregroundColour))
                }
            } else if viewModel.settings.mediaPlayer.showSuggestions {
                SuggestionView()
            }
        }
        // Take up all the space we need in portrait, only take up what we need in landscape.
        .fixedSize(
            horizontal: isLandscape,
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
            .colorMultiply(Color(viewModel.modularBackgroundColorMultiply))
            .animation(.easeInOut, value: viewModel.artworkColour)
    }
    
    @ViewBuilder
    var songDetailsButton: some View {
        Button {
            viewModel.openNowPlayingApp()
        } label: {
            HStack {
                albumArtwork
                if !isLandscape {
                    trackDetails
                }
            }
        }
        .layoutPriority(-1)
    }
    
    @ViewBuilder
    var albumArtwork: some View {
        if let image = viewModel.albumArtwork {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 45, maxHeight: 45)
                .cornerRadius(style.artworkRadius)
                .shadow(color: .black.opacity(0.4), radius: style.artworkRadius)
        }
    }
    
    @ViewBuilder
    var trackDetails: some View {
        let isMarquee = viewModel.settings.mediaPlayer.isMarqueeLabels
        
        VStack(alignment: .leading, spacing: isMarquee ? 0.0 : 4.0) {
            textView(isMarquee: isMarquee, isTrackLabel: true)
            textView(isMarquee: isMarquee, isTrackLabel: false)
        }
    }
    
    @ViewBuilder
    func textView(isMarquee: Bool, isTrackLabel: Bool) -> some View {
        let text = isTrackLabel ? viewModel.trackName : viewModel.artistName
        let fontSize = isTrackLabel ? 15.0 : 12.0
        
        if isMarquee {
            MarqueeText(
                text: text,
                color: viewModel.foregroundColour,
                font: .systemFont(ofSize: fontSize),
                rate: isTrackLabel ? 50 : 60,
                fadeLength: isTrackLabel ? 10.0 : 20.0,
                isScrollable: isVisibleLockScreen
            )
        } else {
            Text(viewModel.trackName)
                .dodoFont(size: fontSize)
                .foregroundColor(Color(viewModel.foregroundColour))
                .lineLimit(1)
        }
    }
}
