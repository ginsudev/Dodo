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
    @EnvironmentObject var appsManager: AppsManager
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
            appsManager.open(app: .custom(appsManager.suggestedAppBundleIdentifier))
        } label: {
            HStack {
                Image(uiImage: viewModel.suggestedAppIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 45, maxHeight: 45)
                openAppButtonText
            }
        }
    }
    
    var openAppButtonText: some View {
        VStack(alignment: .leading) {
            Text(LocalisedText.recommended.text())
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .regular, design: PreferenceManager.shared.settings.fontType))
            Text(LocalisedText.tap.text())
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
                Text("\(Image(systemName: "airplayaudio")) \(LocalisedText.bluetooth.text())")
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
        } else {
            return .iconWithText
        }
    }
}
