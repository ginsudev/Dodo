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
            if let appearance = settings?.appearance {
                Text(timeString)
                    .foregroundColor(Color(settings.colors.timeColor))
                    .font(
                        .system(
                            size: appearance.timeFontSize,
                            design: appearance.selectedFont.representedFont
                        )
                    )
                Text(dateString)
                    .foregroundColor(Color(settings.colors.dateColor))
                    .font(
                        .system(
                            size: appearance.dateFontSize,
                            design: appearance.selectedFont.representedFont
                        )
                    )
            }
        }
        .lineLimit(1)
        .onReceive(NotificationCenter.default.publisher(for: .refreshContent).prepend(.prepended)) { _ in
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
