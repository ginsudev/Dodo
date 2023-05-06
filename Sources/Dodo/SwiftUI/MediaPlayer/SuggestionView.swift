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
    @Environment(\.isLandscape) var isLandscape
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
                    .frame(
                        maxWidth: 45,
                        maxHeight: 45
                    )
                openAppButtonText
            }
        }
    }
    
    var openAppButtonText: some View {
        VStack(alignment: .leading) {
            Text(LocalisedText.recommended.text)
                .foregroundColor(.white)
                .font(
                    .system(
                        size: 15.0,
                        design: viewModel.settings.appearance.selectedFont.representedFont
                    )
                )
            Text(LocalisedText.tap.text)
                .foregroundColor(Color(UIColor.lightText))
                .font(
                    .system(
                        size: 13.0,
                        design: viewModel.settings.appearance.selectedFont.representedFont
                    )
                )
        }
        .multilineTextAlignment(.leading)
    }
    
    var bluetoothButton: some View {
        Button {
            AVRoutePickerView()._routePickerButtonTapped(nil)
        } label: {
            bluetoothButtonLabel
        }
    }
    
    var bluetoothButtonType: BluetoothButtonType  {
        if (UIDevice._hasHomeButton() || isLandscape) && !UIDevice.currentIsIPad() {
            return .icon
        } else {
            return .iconWithText
        }
    }
    
    @ViewBuilder
    var bluetoothButtonLabel: some View {
        let foregroundColor = Color(viewModel.bluetoothColor.suitableForegroundColour())
        let backgroundColor = Color(viewModel.bluetoothColor)
        
        if bluetoothButtonType == .iconWithText {
            Text("\(Image(systemName: "airplayaudio")) \(LocalisedText.bluetooth.text)")
                .font(
                    .system(
                        size: 13.0,
                        design: viewModel.settings.appearance.selectedFont.representedFont
                    )
                )
                .padding(
                    EdgeInsets(
                        top: 10,
                        leading: 15,
                        bottom: 10,
                        trailing: 15
                    )
                )
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(Capsule())
        } else {
            Image(systemName: "airplayaudio")
                .foregroundColor(foregroundColor)
                .padding(Padding.medium)
                .background(backgroundColor)
                .clipShape(Circle())
        }
    }
}
