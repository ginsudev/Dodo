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
    @Environment(\.isLandscape)
    var isLandscape
    
    @EnvironmentObject
    var appsManager: AppsManager
    
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
                openAppButtonImage
                openAppButtonText
            }
        }
    }
    
    var openAppButtonImage: some View {
        Image(uiImage: viewModel.suggestedAppIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 45, maxHeight: 45)
    }
    
    var openAppButtonText: some View {
        VStack(alignment: .leading) {
            Text(Copy.Media.recommended)
                .foregroundColor(.white)
                .dodoFont(size: 15.0)
            
            Text(Copy.Media.tap)
                .foregroundColor(Color(UIColor.lightText))
                .dodoFont(size: 13.0)
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
        if UIDevice._hasHomeButton() || isLandscape {
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
            Text("\(Image(systemName: "airplayaudio")) \(Copy.Media.bluetooth)")
                .dodoFont(size: 13.0)
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
