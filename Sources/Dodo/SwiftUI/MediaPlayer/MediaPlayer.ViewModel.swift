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
        
        //MARK: - Singleton and static
        
        static let shared = ViewModel()
        
        static let themePath: String = GSUtilities.sharedInstance().correctedFilePathFromPath(
            withRootPrefix: ":root:Library/Application Support/Dodo/Themes/\(Settings.themeName)/"
        )
        
        //MARK: - Properties
        
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
        @Published var albumArtwork = UIImage(systemName: "music.note")! {
            didSet {
                DispatchQueue.main.async {
                    self.artworkColour = self.albumArtwork.dominantColour()
                }
            }
        }

        @Published var playPauseIcon = UIImage(named: MediaPlayer.ViewModel.themePath + "pause.png")

        @Published var artworkColour: UIColor = .black {
            didSet {
                guard Settings.playerStyle == .modular else {
                    return
                }
                DispatchQueue.main.async {
                    self.foregroundColour = self.artworkColour.suitableForegroundColour()
                }
            }
        }
        
        @Published var foregroundColour: UIColor = .white
        
        //MARK: - Media controlling
        func togglePlayPause(shouldPlay play: Bool) {
            let iconPath = MediaPlayer.ViewModel.themePath + (play ? "pause": "play") + ".png"
            DispatchQueue.main.async {
                self.playPauseIcon = UIImage(named: iconPath)
            }
        }
        
        func updateInfo() {
            //Update track info (Artwork, title, artist, etc..).
            MRMediaRemoteGetNowPlayingInfo(.main, { information in
                guard let dict = information as? [String: AnyObject] else {
                    return
                }
                guard let contentItem = MRContentItem(nowPlayingInfo: dict) else {
                    return
                }
                //Track name & artist
                self.trackName = contentItem.metadata.title ?? ""
                self.artistName = contentItem.metadata.trackArtistName ?? ""
                //Album artwork
                if let data = dict["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                    self.albumArtwork = UIImage(data: data)!
                }
                //Playing status
                self.togglePlayPause(shouldPlay: (contentItem.metadata.playbackRate > 0))
            })
        }
        
        //MARK: - Now playing identifier
        
        func nowPlayingAppIdentifier() -> String? {
            guard let app = SBMediaController.sharedInstance().nowPlayingApplication() else {
                return nil
            }
            return app.bundleIdentifier
        }
    }
}
