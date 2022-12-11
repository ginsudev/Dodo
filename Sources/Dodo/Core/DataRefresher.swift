//
//  DataRefresher.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import UIKit

final class DataRefresher {
    static let shared = DataRefresher()
    private var timer = Timer()
    var timerRunning = false
    var screenOn = false
    
    public func toggleTimer(on enable: Bool) {
        // Disable the timer if requested.
        guard Settings.timeMediaPlayerStyle != .mediaPlayer else {
            refreshOnce()
            return
        }
        
        guard enable else {
            if self.timer.isValid {
                self.timer.invalidate()
                timerRunning = false
            }
            return
        }
        // One timer only
        guard !self.timer.isValid else {
            return
        }
        // Start timer.
        self.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.refresh),
            userInfo: nil,
            repeats: true
        )
        self.timer.fire()
        // Update timer status.
        timerRunning = true
        // Update values that only need to be updated once.
        refreshOnce()
    }
    
    @objc private func refresh() {
        // Refreshing time and date
        TimeDateView.ViewModel.shared.update(
            timeTemplate: Settings.timeTemplate,
            dateTemplate: Settings.dateTemplate
        )
    }
    
    private func refreshOnce() {
        WeatherView.ViewModel.shared.updateWeather(forced: false)
        // Charging indication
        if UIDevice.current.batteryState != .unplugged && Settings.hasChargingIndication {
            chargingIndication()
        }
    }
    
    private func chargingIndication() {
        let chargeColour = UIColor(red: 0.28, green: 0.57, blue: 0.18, alpha: 1.00)
        let prevColour = MediaPlayer.ViewModel.shared.artworkColour
        MediaPlayer.ViewModel.shared.artworkColour = chargeColour
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            guard MediaPlayer.ViewModel.shared.artworkColour == chargeColour else {
                return
            }
            MediaPlayer.ViewModel.shared.artworkColour = prevColour
        }
    }
}
