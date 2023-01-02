//
//  MediaPlayer.ViewModel.swift
//  
//
//  Created by Noah Little on 9/12/2022.
//

import Foundation
import DodoC

extension MediaPlayer {
    final class ViewModel: ObservableObject {
        static let shared = ViewModel()
        
        static let themePath: String = GSUtilities.sharedInstance().correctedFilePathFromPath(
            withRootPrefix: ":root:Library/Application Support/Dodo/Themes/\(PreferenceManager.shared.settings.themeName)/"
        )
                
        @Published var hasActiveMediaApp = false {
            didSet {
                guard !hasActiveMediaApp else {
                    return
                }
                artworkColour = .black
            }
        }

        @Published var trackName = ""
        @Published var artistName = ""
        @Published var albumArtwork: UIImage? = UIImage(systemName: "music.note") {
            didSet {
                DispatchQueue.main.async { [weak self] in
                    self?.artworkColour = self?.albumArtwork?.dominantColour() ?? .black
                }
            }
        }

        @Published var playPauseIcon = UIImage(named: MediaPlayer.ViewModel.themePath + "pause.png")

        @Published var artworkColour: UIColor = .black {
            didSet {
                guard PreferenceManager.shared.settings.playerStyle == .modular else {
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.foregroundColour = self?.artworkColour.suitableForegroundColour() ?? .white
                }
            }
        }
        
        @Published var foregroundColour: UIColor = .white
        
        func togglePlayPause(shouldPlay play: Bool) {
            let iconPath = MediaPlayer.ViewModel.themePath + (play ? "pause": "play") + ".png"
            DispatchQueue.main.async { [weak self] in
                self?.playPauseIcon = UIImage(named: iconPath)
            }
        }
        
        func updateInfo() {
            //Update track info (Artwork, title, artist, etc..).
            MRMediaRemoteGetNowPlayingInfo(.main, { [weak self] information in
                guard let dict = information as? [String: AnyObject] else {
                    return
                }
                if let contentItem = MRContentItem(nowPlayingInfo: dict),
                   let metadata = contentItem.metadata {
                    //Track name & artist
                    self?.trackName = metadata.title ?? ""
                    self?.artistName = metadata.trackArtistName ?? ""
                    //Album artwork
                    if let data = dict["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                        self?.albumArtwork = UIImage(data: data)
                    }
                    //Playing status
                    self?.togglePlayPause(shouldPlay: (metadata.playbackRate > 0))
                }
            })
        }
                
        func nowPlayingAppIdentifier() -> String? {
            guard let app = SBMediaController.sharedInstance().nowPlayingApplication() else {
                return nil
            }
            return app.bundleIdentifier
        }
    }
}
