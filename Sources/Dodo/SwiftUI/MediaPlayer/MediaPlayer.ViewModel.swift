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
        @Published var albumArtwork: UIImage? = UIImage(systemName: "play.rectangle.fill") {
            didSet {
                self.artworkColour = self.albumArtwork?.dominantColour() ?? .black
            }
        }

        @Published var playPauseIcon = UIImage(named: MediaPlayer.ViewModel.themePath + "pause.png")

        @Published var artworkColour: UIColor = .black {
            didSet {
                guard PreferenceManager.shared.settings.playerStyle == .modular else {
                    return
                }
                self.foregroundColour = self.artworkColour.suitableForegroundColour()
            }
        }
        
        @Published var foregroundColour: UIColor = .white
        
        init() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didChangePlaybackState(notification:)),
                name: NSNotification.Name(Notifications.nc_didChangeIsPlaying),
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didChangeNowPlayingInfo),
                name: NSNotification.Name(Notifications.nc_didChangeNowPlayingInfo),
                object: nil
            )
        }
        
        @objc func didChangePlaybackState(notification: Notification) {
            hasActiveMediaApp = nowPlayingAppIdentifier() != nil
            guard hasActiveMediaApp else {
                return
            }
            if let userInfo = notification.userInfo,
               let isPlaying = userInfo["kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"] as? Bool {
                togglePlayPause(shouldPlay: isPlaying)
            }
        }
        
        @objc func didChangeNowPlayingInfo() {
            //Update track info (Artwork, title, artist, etc..).
            MRMediaRemoteGetNowPlayingInfo(
                .main,
                { [weak self] information in
                    guard let dict = information as? [String: AnyObject] else {
                        return
                    }
                    if let contentItem = MRContentItem(nowPlayingInfo: dict),
                       let metadata = contentItem.metadata {
                        //Track name & artist
                        if let title = metadata.title {
                            self?.trackName = title
                        }
                        if let trackArtistName = metadata.trackArtistName {
                            self?.artistName = trackArtistName
                        }
                        //Album artwork
                        if let artwork = contentItem.artwork,
                           let imageData = artwork.imageData,
                           let image = UIImage(data: imageData) {
                            self?.albumArtwork = image
                        }
                    }
                }
            )
        }
        
        func togglePlayPause(shouldPlay play: Bool) {
            let iconPath = MediaPlayer.ViewModel.themePath + (play ? "pause": "play") + ".png"
            self.playPauseIcon = UIImage(named: iconPath)
        }
                
        func nowPlayingAppIdentifier() -> String? {
            guard let app = SBMediaController.sharedInstance().nowPlayingApplication() else {
                return nil
            }
            return app.bundleIdentifier
        }
    }
}

extension MediaPlayer.ViewModel {
    func temporarilySwapColor(_ newColor: UIColor) {
        let previousColor = artworkColour
        artworkColour = newColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            self?.artworkColour = previousColor
        }
    }
}
