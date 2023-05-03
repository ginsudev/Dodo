//
//  MediaControlsView.swift
//  
//
//  Created by Noah Little on 23/7/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct MediaControlsView: View {
    enum MediaControl: CaseIterable, Identifiable {
        case previous
        case play
        case pause
        case next
        
        var id: Self { self }
        
        var imageName: String {
            switch self {
            case .previous: return MediaPlayer.ViewModel.themePath + "previous.png"
            case .play: return MediaPlayer.ViewModel.themePath + "play.png"
            case .pause: return MediaPlayer.ViewModel.themePath + "pause.png"
            case .next: return MediaPlayer.ViewModel.themePath + "next.png"
            }
        }
        
        var size: CGFloat {
            switch self {
            case .play, .pause: return 44.0
            default: return 34.0
            }
        }
        
        static var isPlayingControls: [Self] {
            allCases.filter { $0 != .play }
        }
        
        static var isPausedControls: [Self] {
            allCases.filter { $0 != .pause }
        }
    }
    
    let visibleControls: [MediaControl]
    let onDidTapControl: (MediaControl) -> Void

    var body: some View {
        HStack {
            ForEach(visibleControls) { control in
                if let image = UIImage(named: control.imageName) {
                    Button {
                        onDidTapControl(control)
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .frame(
                                width: control.size,
                                height: control.size
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
}

//MARK: - Private

private extension MediaControlsView {
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.7 : 1)
        }
    }
}
