//
//  AlarmView.swift
//  
//
//  Created by Noah Little on 7/1/2023.
//

import SwiftUI

struct AlarmView: View {
    @EnvironmentObject var appsManager: AppsManager

    let alarm: Alarm
    
    var body: some View {
        StatusItemView(
            image: Image(systemName: "alarm.fill"),
            tint: Colors.alarmIconColor,
            text: TimeDateView.ViewModel.shared.getDate(
                fromTemplate: .time,
                date: alarm.nextFireDate
            ),
            onLongHoldAction: {
                appsManager.open(app: .defined(.clock))
                HapticManager.playHaptic(withIntensity: .custom(.medium))
            }
        )
    }
}
