//
//  TimeDateView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

struct TimeDateView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0.0
        ) {
            Text(viewModel.timeString)
                .foregroundColor(Color(viewModel.settings.colors.timeColor))
                .font(
                    .system(
                        size: viewModel.settings.appearance.timeFontSize,
                        design: viewModel.settings.appearance.selectedFont.representedFont
                    )
                )
            dateView
                .animation(.easeInOut)
        }
        .disabled(viewModel.isDisplayingLocationName)
        .lineLimit(1)
        .onReceive(NotificationCenter.default.publisher(for: .refreshContent)) { _ in
            viewModel.refreshTime()
        }
        .onTapGesture {
            viewModel.onDidTapTime()
        }
    }
}

private extension TimeDateView {
    var dateView: some View {
        HStack {
            if let imageName = viewModel.locationImageName {
                Image(systemName: imageName)
                    .opacity(0.4)
            }
            
            if viewModel.isDisplayingLocationName,
               let locationName = viewModel.locationName {
                Text(locationName)
                    .transition(.opacity.combined(with: .slide))
            } else {
                Text(viewModel.dateString)
                    .transition(.opacity.combined(with: .slide))
            }
            
        }
        .foregroundColor(Color(viewModel.settings.colors.dateColor))
        .font(
            .system(
                size: viewModel.settings.appearance.dateFontSize,
                design: viewModel.settings.appearance.selectedFont.representedFont
            )
        )
    }
}
