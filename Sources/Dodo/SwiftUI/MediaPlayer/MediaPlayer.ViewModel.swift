//
//  MediaPlayer.ViewModel.swift
//  
//
//  Created by Noah Little on 9/12/2022.
//

import Foundation
import DodoC
import GSCore

// MARK: - Public

extension MediaPlayer {
    final class ViewModel: ObservableObject {
        static let shared = ViewModel()
        static let themePath: String = "/Library/Application Support/Dodo/Themes/\(PreferenceManager.shared.settings.themeName)/".rootify
        
        var modularBackgroundColorMultiply: UIColor {
            if !hasActiveMediaApp,
               let image = UIImage.icon(bundleIdentifier: AppsManager.shared.suggestedAppBundleIdentifier) {
                return image.dominantColour()
            } else {
                return artworkColour
            }
        }
        
        @Published var hasActiveMediaApp = false {
            didSet {
                guard !hasActiveMediaApp else {
                    if let identifier = nowPlayingAppIdentifier() {
                        AppsManager.shared.suggestedAppBundleIdentifier = identifier
                    }
                    return
                }
                artworkColour = .black
            }
        }
        
        @Published var albumArtwork: UIImage? = UIImage(systemName: "play.rectangle.fill") {
            didSet {
                self.artworkColour = self.albumArtwork?.dominantColour() ?? .black
            }
        }
        
        @Published var artworkColour: UIColor = .black {
            didSet {
                guard PreferenceManager.shared.settings.playerStyle == .modular else {
                    return
                }
                self.foregroundColour = self.artworkColour.suitableForegroundColour()
            }
        }

        @Published var trackName = ""
        @Published var artistName = ""
        @Published var playPauseIcon = UIImage(named: MediaPlayer.ViewModel.themePath + "pause.png")
        @Published var foregroundColour: UIColor = .white
        
        init() {
            addObservers()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

// MARK: - Internal

extension MediaPlayer.ViewModel {
    func temporarilySwapColor(_ newColor: UIColor) {
        let previousColor = artworkColour
        artworkColour = newColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            self?.artworkColour = previousColor
        }
    }
    
    func togglePlayPause(shouldPlay play: Bool) {
        let iconPath = MediaPlayer.ViewModel.themePath + (play ? "pause": "play") + ".png"
        DispatchQueue.main.async {
            self.playPauseIcon = UIImage(named: iconPath)
        }
    }
    
    func nowPlayingAppIdentifier() -> String? {
        guard let app = SBMediaController.sharedInstance().nowPlayingApplication() else { return nil }
        return app.bundleIdentifier
    }
    
    func openNowPlayingApp() {
        if let nowPlayingIdentifier = nowPlayingAppIdentifier() {
            AppsManager.shared.open(app: .custom(nowPlayingIdentifier))
        }
    }
}

// MARK: - Private

private extension MediaPlayer.ViewModel {
    func addObservers() {
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
        DispatchQueue.main.async { [weak self] in
            self?.hasActiveMediaApp = self?.nowPlayingAppIdentifier() != nil
            guard self?.hasActiveMediaApp == true else { return }
            
            if let userInfo = notification.userInfo,
               let isPlaying = userInfo["kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"] as? Bool {
                self?.togglePlayPause(shouldPlay: isPlaying)
            }
        }
    }
    
    @objc func didChangeNowPlayingInfo() {
        //Update track info (Artwork, title, artist, etc..).
        MRMediaRemoteGetNowPlayingInfo(
            .main,
            { [weak self] information in
                guard let dict = information as? [String: AnyObject] else { return }
                if let contentItem = MRContentItem(nowPlayingInfo: dict),
                   let metadata = contentItem.metadata {
                    //Track name & artist
                    DispatchQueue.main.async {
                        if let title = metadata.title {
                            self?.trackName = title
                        }
                        if let trackArtistName = metadata.trackArtistName {
                            self?.artistName = trackArtistName
                        }
                        //Album artwork
                        if let artworkData = dict["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data,
                           let image = UIImage(data: artworkData) {
                            self?.albumArtwork = image
                        }
                    }
                }
            }
        )
    }
}
