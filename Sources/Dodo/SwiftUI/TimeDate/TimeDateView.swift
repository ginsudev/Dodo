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
        VStack (alignment: .leading, spacing: 0.0) {
            Text(viewModel.time)
                .foregroundColor(Color(Colors.timeColor))
                .font(.system(size: 50, weight: .regular, design: PreferenceManager.shared.settings.fontType))
            Text(viewModel.date)
                .foregroundColor(Color(Colors.dateColor))
                .font(.system(size: 15, weight: .regular, design: PreferenceManager.shared.settings.fontType))
        }
        .minimumScaleFactor(0.3)
        .lineLimit(1)
    }
}
