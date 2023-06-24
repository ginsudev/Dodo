//
//  MediaPlayer.ViewModel.swift
//  
//
//  Created by Noah Little on 9/12/2022.
//

import Foundation
import DodoC
import GSCore
import Combine

// MARK: - Public

extension MediaPlayer {
    final class ViewModel: ObservableObject {
        // Private keys
        private static let isPlayingKey = "kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey"
        private static let artworkDataKey = "kMRMediaRemoteNowPlayingInfoArtworkData"

        static let themePath: String = PreferenceManager.shared.settings.mediaPlayer.themePath
        
        private var bag: Set<AnyCancellable> = []
        
        @Published
        private var mediaAppBundleID: String?
        
        @Published
        var albumArtwork: UIImage? = UIImage(systemName: "play.rectangle.fill")
        
        @Published
        var artworkColour: UIColor = .black

        @Published
        private(set) var isPlaying = false
        
        @Published
        var trackName = ""
        
        @Published
        var artistName = ""
        
        @Published
        var foregroundColour: UIColor = .white
        
        var hasActiveMediaApp: Bool { mediaAppBundleID != nil }
        
        var modularBackgroundColorMultiply: UIColor {
            if !hasActiveMediaApp,
               let image = UIImage.icon(bundleIdentifier: AppsManager.shared.suggestedAppBundleIdentifier) {
                return image.dominantColour()
            } else {
                return artworkColour
            }
        }
        
        var previousBackgroundColor: UIColor?
        
        let settings = PreferenceManager.shared.settings
        
        init() {
            subscribe()
        }
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
    
    func openNowPlayingApp() {
        guard let mediaAppBundleID else { return }
        AppsManager.shared.open(app: .custom(mediaAppBundleID))
    }
}

// MARK: - Private

private extension MediaPlayer.ViewModel {
    func subscribe() {
        NotificationCenter.default.publisher(for: .didChangeIsPlaying)
            .map { $0.userInfo?[Self.isPlayingKey] as? Bool ?? false }
            .sink { [weak self] in self?.didChangePlaybackState(isPlaying: $0) }
            .store(in: &bag)
        
        NotificationCenter.default.publisher(for: .didChangeNowPlayingInfo)
            .prepend(.prepended)
            .sink { [weak self] _ in self?.didChangeNowPlayingInfo() }
            .store(in: &bag)
        
        $mediaAppBundleID
            .sink { [ weak self] in
                if let identifier = $0 {
                    AppsManager.shared.suggestedAppBundleIdentifier = identifier
                } else {
                    self?.artworkColour = .black
                }
            }
            .store(in: &bag)
        
        if settings.mediaPlayer.isEnabledMediaBackdrop {
            $albumArtwork
                .map { $0?.dominantColour() }
                .replaceNil(with: .black)
                .assign(to: &$artworkColour)
        }
        
        if settings.mediaPlayer.playerStyle == .modular {
            $artworkColour
                .map { $0.suitableForegroundColour() }
                .assign(to: &$foregroundColour)
        }
    }
    
    func didChangePlaybackState(isPlaying: Bool) {
        mediaAppBundleID = nowPlayingAppIdentifier()
        self.isPlaying = hasActiveMediaApp && isPlaying
    }
    
    func nowPlayingAppIdentifier() -> String? {
        guard let app = SBMediaController.sharedInstance().nowPlayingApplication() else { return nil }
        return app.bundleIdentifier
    }
    
    func didChangeNowPlayingInfo() {
        // Update track info (Artwork, title, artist, etc..).
        MRMediaRemoteGetNowPlayingInfo(.main) { [weak self] dict in
            guard let dict = dict as? [String: Any],
                  let contentItem = MRContentItem(nowPlayingInfo: dict),
                  let metadata = contentItem.metadata
            else { return }
            
            if let title = metadata.title {
                self?.trackName = title
            }
            
            if let trackArtistName = metadata.trackArtistName {
                self?.artistName = trackArtistName
            }
            
            if let artworkData = dict[Self.artworkDataKey] as? Data,
               let image = UIImage(data: artworkData) {
                self?.albumArtwork = image
            }
        }
    }
}
