//
//  ChargingIcon.swift
//  
//
//  Created by Noah Little on 14/12/2022.
//

import SwiftUI

struct ChargingIcon: View {
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        Image(systemName: viewModel.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: 18,
                height: 18
            )
            .foregroundColor(viewModel.indicationColor)
    }
}
