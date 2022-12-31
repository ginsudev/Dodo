//
//  SuggestionView.swift
//  
//
//  Created by Noah Little on 27/11/2022.
//

import SwiftUI
import DodoC

//MARK: - Public

struct SuggestionView: View {
    @EnvironmentObject var dimensions: Dimensions
    private let viewModel = ViewModel()

    var body: some View {
        HStack {
            openAppButton
            Spacer()
            bluetoothButton
        }
    }
}

//MARK: - Private

private extension SuggestionView {
    var openAppButton: some View {
        Button {
            viewModel.appsManager.openApplication(
                withIdentifier: viewModel.appsManager.suggestedAppBundleIdentifier
            )
        } label: {
            HStack {
                Image(uiImage: UIImage(withBundleIdentifier: viewModel.appsManager.suggestedAppBundleIdentifier))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 45, maxHeight: 45)
                openAppButtonText
            }
        }
    }
    
    var openAppButtonText: some View {
        VStack(alignment: .leading) {
            Text(viewModel.text(for: .recommended))
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .regular, design: PreferenceManager.shared.settings.fontType))
            Text(viewModel.text(for: .tap))
                .foregroundColor(Color(UIColor.lightText))
                .font(.system(size: 13, weight: .regular, design: PreferenceManager.shared.settings.fontType))
        }
        .multilineTextAlignment(.leading)
    }
    
    var bluetoothButton: some View {
        Button {
            AVRoutePickerView()._routePickerButtonTapped(nil)
        } label: {
            if bluetoothButtonType == .icon {
                Image(systemName: "airplayaudio")
                    .foregroundColor(Color(viewModel.bluetoothColor.suitableForegroundColour()))
                    .padding(Dimensions.Padding.medium)
                    .background(Color(viewModel.bluetoothColor))
                    .clipShape(Circle())
            } else {
                Text("\(Image(systemName: "airplayaudio")) \(viewModel.text(for: .bluetooth))")
                    .font(.system(
                        size: 13,
                        weight: .regular,
                        design: PreferenceManager.shared.settings.fontType)
                    )
                    .padding(EdgeInsets(
                        top: 10,
                        leading: 15,
                        bottom: 10,
                        trailing: 15)
                    )
                    .foregroundColor(Color(viewModel.bluetoothColor.suitableForegroundColour()))
                    .background(Color(viewModel.bluetoothColor))
                    .clipShape(Capsule())
            }
        }
    }
    
    var bluetoothButtonType: BluetoothButtonType  {
        if (UIDevice._hasHomeButton() || dimensions.isLandscape) && !UIDevice.currentIsIPad() {
            return .icon
        }
        return .iconWithText
    }
}
