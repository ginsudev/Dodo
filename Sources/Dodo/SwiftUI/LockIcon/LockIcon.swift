//
//  LockIcon.swift
//  
//
//  Created by Noah Little on 11/12/2022.
//

import SwiftUI

struct LockIcon: View {
    @StateObject private var viewModel = ViewModel.shared

    var body: some View {
        Image(systemName: viewModel.lockImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: 18,
                height: 18
            )
            .foregroundColor(Color(Colors.lockIconColor))
    }
}
