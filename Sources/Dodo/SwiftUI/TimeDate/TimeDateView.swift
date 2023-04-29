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
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0.0
        ) {
            Text(timeString)
                .foregroundColor(Color(Colors.timeColor))
                .font(
                    .system(
                        size: PreferenceManager.shared.settings.timeFontSize,
                        design: PreferenceManager.shared.settings.selectedFont.representedFont
                    )
                )
            Text(dateString)
                .foregroundColor(Color(Colors.dateColor))
                .font(
                    .system(
                        size: PreferenceManager.shared.settings.dateFontSize,
                        design: PreferenceManager.shared.settings.selectedFont.representedFont
                    )
                )
        }
        .lineLimit(1)
        .onReceive(NotificationCenter.default.publisher(for: .refreshContent).prepend(.prepended)) { _ in
            refreshDates()
        }
    }
}

private extension TimeDateView {
    func refreshDates() {
        if let time = PreferenceManager.shared.settings.timeTemplate.dateString() {
            timeString = time
        }
        if let date = PreferenceManager.shared.settings.dateTemplate.dateString() {
            dateString = date
        }
    }
}
