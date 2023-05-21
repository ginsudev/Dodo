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
        static let themePath: String = PreferenceManager.shared.settings.mediaPlayer.themePath
        let settings = PreferenceManager.shared.settings
        
        var modularBackgroundColorMultiply: UIColor {
            if !hasActiveMediaApp,
               let image = UIImage.icon(bundleIdentifier: AppsManager.shared.suggestedAppBundleIdentifier) {
                return image.dominantColour()
            } else {
                return artworkColour
            }
        }
        
        var previousBackgroundColor: UIColor?
        
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
                guard settings.mediaPlayer.isEnabledMediaBackdrop else { return }
                self.artworkColour = self.albumArtwork?.dominantColour() ?? .black
            }
        }
        
        @Published var artworkColour: UIColor = .black {
            didSet {
                guard settings.mediaPlayer.playerStyle == .modular else { return }
                self.foregroundColour = self.artworkColour.suitableForegroundColour()
            }
        }

        @Published private(set) var isPlaying = false
        @Published var trackName = ""
        @Published var artistName = ""
        @Published var foregroundColour: UIColor = .white
    }
}

// MARK: - Internal

extension MediaPlayer.ViewModel {
    func onDidTapMediaControl(_ control: MediaControlsView.MediaControl) {
        switch control {
        case .previous:
            SBMediaController.sharedInstance().changeTrack(-1, eventSource: 0)
        case .play, .pause:
            SBMediaController.sharedInstance().togglePlayPause(forEventSource: 0)
        case .next:
            SBMediaController.sharedInstance().changeTrack(1, eventSource: 0)
        }
    }
    
    func activateChargeIndication() {
        guard UIDevice.current.batteryState != .unplugged else { return }
        temporarilySwapColor(UIDevice.current.batteryLevelColorRepresentation)
    }

    func temporarilySwapColor(_ newColor: UIColor) {
        // Don't go further if this function is already being executed.
        guard previousBackgroundColor == nil else { return }
        
        previousBackgroundColor = artworkColour
        artworkColour = newColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            guard let self, let previousBackgroundColor else { return }
            artworkColour = previousBackgroundColor
            self.previousBackgroundColor = nil
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
    
    func didChangeNowPlayingInfo() {
        //Update track info (Artwork, title, artist, etc..).
        MRMediaRemoteGetNowPlayingInfo(
            .main,
            { [weak self] information in
                guard let dict = information as? [String: AnyObject] else { return }
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
                    if let artworkData = dict["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data,
                       let image = UIImage(data: artworkData) {
                        self?.albumArtwork = image
                    }
                }
            }
        )
    }
    
    func didChangePlaybackState(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isPlaying = userInfo["kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"] as? Bool
        else { return }
        didChangePlaybackState(isPlaying: isPlaying)
    }
}

// MARK: - Private

private extension MediaPlayer.ViewModel {
    func didChangePlaybackState(isPlaying: Bool) {
        hasActiveMediaApp = nowPlayingAppIdentifier() != nil
        self.isPlaying = hasActiveMediaApp && isPlaying
    }
}
