//
//  MediaControlImage.swift
//  
//
//  Created by Noah Little on 10/12/2022.
//

import SwiftUI

struct MediaControlImage: View {
    enum PlaybackButtonType: CGFloat {
        case playPause = 44.0
        case prevNext = 34.0
    }
    
    private let image: UIImage
    private let playbackButtonType: PlaybackButtonType
    
    init(
        image: UIImage,
        playbackButtonType: PlaybackButtonType
    ) {
        self.image = image
        self.playbackButtonType = playbackButtonType
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .renderingMode(.template)
            .frame(
                width: playbackButtonType.rawValue,
                height: playbackButtonType.rawValue
            )
    }
}
