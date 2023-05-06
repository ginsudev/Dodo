//
//  TimeDateView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

struct TimeDateView: View {
    @State private var timeString = "--:--"
    @State private var dateString = "--/--/--"
    private let settings = PreferenceManager.shared.settings

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0.0
        ) {
            Text(timeString)
                .foregroundColor(Color(settings.colors.timeColor))
                .font(
                    .system(
                        size: settings.appearance.timeFontSize,
                        design: settings.appearance.selectedFont.representedFont
                    )
                )
            Text(dateString)
                .foregroundColor(Color(settings.colors.dateColor))
                .font(
                    .system(
                        size: settings.appearance.dateFontSize,
                        design: settings.appearance.selectedFont.representedFont
                    )
                )
        }
        .lineLimit(1)
        .onReceive(NotificationCenter.default.publisher(for: .refreshContent)) { _ in
            refreshDates()
        }
    }
}

private extension TimeDateView {
    func refreshDates() {
        if let time = settings.timeDate.timeTemplate.dateString() {
            timeString = time
        }
        if let date = settings.timeDate.dateTemplate.dateString() {
            dateString = date
        }
    }
}
