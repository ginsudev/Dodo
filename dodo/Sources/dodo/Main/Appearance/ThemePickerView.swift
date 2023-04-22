//
//  ThemePickerView.swift
//  
//
//  Created by Noah Little on 7/4/2023.
//

import SwiftUI
import GSCore

struct ThemePickerView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    private let viewModel = ViewModel()
    
    var body: some View {
        List(viewModel.themes) { theme in
            Button {
                preferenceStorage.themeName = theme.name
                viewModel.saveWithID(theme.id)
            } label: {
                HStack {
                    SubtitleText(
                        title: theme.name,
                        subtitle: theme.twitter
                    )
                    Spacer()
                    checkmarkView(isSelected: viewModel.savedID() == theme.id)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Player button theme")
    }
    
    @ViewBuilder
    private func checkmarkView(isSelected: Bool) -> some View {
        if isSelected {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Colors.tint)
        } else {
            Image(systemName: "circle")
                .foregroundColor(.secondary)
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
