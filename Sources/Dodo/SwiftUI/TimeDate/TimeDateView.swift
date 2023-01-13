//
//  TimeDateView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

struct TimeDateView: View {
    @StateObject private var viewModel = ViewModel.shared
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0.0
        ) {
            Text(viewModel.time)
                .foregroundColor(Color(Colors.timeColor))
                .font(
                    .system(
                        size: PreferenceManager.shared.settings.timeFontSize,
                        weight: .regular,
                        design: PreferenceManager.shared.settings.fontType
                    )
                )
            Text(viewModel.date)
                .foregroundColor(Color(Colors.dateColor))
                .font(
                    .system(
                        size: PreferenceManager.shared.settings.dateFontSize,
                        weight: .regular,
                        design: PreferenceManager.shared.settings.fontType
                    )
                )
        }
        .lineLimit(1)
    }
}
