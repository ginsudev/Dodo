//
//  MediaControls.swift
//  
//
//  Created by Noah Little on 23/7/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct MediaControls: View {
    @EnvironmentObject var mediaModel: MediaPlayer.ViewModel

    var body: some View {
        HStack {
            previousButton
            pausePlayButton
            nextButton
        }
        .buttonStyle(ScaleButtonStyle())
        .foregroundColor(Color(mediaModel.foregroundColour))
    }
}

//MARK: - Private

private extension MediaControls {
    var previousButton: some View {
        Button(action: {
            SBMediaController.sharedInstance().changeTrack(-1, eventSource: 0)
        }){
            MediaControlImage(
                image: UIImage(named: MediaPlayer.ViewModel.themePath + "previous.png")!,
                playbackButtonType: .prevNext
            )
        }
    }
    
    var pausePlayButton: some View {
        Button(action: {
            SBMediaController.sharedInstance().togglePlayPause(forEventSource: 0)
        }){
            MediaControlImage(
                image: mediaModel.playPauseIcon!,
                playbackButtonType: .playPause
            )
        }
    }
    
    var nextButton: some View {
        Button(action: {
            SBMediaController.sharedInstance().changeTrack(1, eventSource: 0)
        }){
            MediaControlImage(
                image: UIImage(named: MediaPlayer.ViewModel.themePath + "next.png")!,
                playbackButtonType: .prevNext
            )
        }
    }
    
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.7 : 1)
        }
    }
}
