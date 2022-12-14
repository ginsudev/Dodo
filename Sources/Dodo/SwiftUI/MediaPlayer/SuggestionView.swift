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
    @State private var appsManager = AppsManager.self
    @State private var bluetoothButtonColor: UIColor = .white
    
    var body: some View {
        HStack {
            openAppButton
                .layoutPriority(-1)
            Spacer()
            bluetoothButton
        }
    }
}

//MARK: - Private

private extension SuggestionView {
    var openAppButton: some View {
        Button {
            appsManager.openApplication(withIdentifier: appsManager.suggestedAppBundleIdentifier)
        } label: {
            HStack {
                Image(uiImage: UIImage(withBundleIdentifier: appsManager.suggestedAppBundleIdentifier))
                    .resizable()
                    .frame(maxWidth: 45, maxHeight: 45)
                    .aspectRatio(contentMode: .fit)
                openAppButtonText
            }
        }
    }
    
    var openAppButtonText: some View {
        VStack(alignment: .leading) {
            Text(ResourceBundle.localisation(for: "Recommended_For_You"))
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .regular, design: PreferenceManager.shared.settings.fontType))
            Text(ResourceBundle.localisation(for: "Tap_To_Listen"))
                .foregroundColor(Color(UIColor.lightText))
                .font(.system(size: 13, weight: .regular, design: PreferenceManager.shared.settings.fontType))
        }
    }
    
    var bluetoothButton: some View {
        Button {
            AVRoutePickerView()._routePickerButtonTapped(nil)
        } label: {
            Text("\(Image(systemName: "airplayaudio")) \(ResourceBundle.localisation(for: "Bluetooth"))")
                .foregroundColor(Color(bluetoothButtonColor.suitableForegroundColour()))
                .font(.system(size: 13, weight: .regular, design: PreferenceManager.shared.settings.fontType))
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .background(Color(bluetoothButtonColor))
                .clipShape(Capsule())
                .onAppear {
                    if PreferenceManager.shared.settings.playerStyle == .classic {
                        bluetoothButtonColor = UIImage(withBundleIdentifier: appsManager.suggestedAppBundleIdentifier)
                            .dominantColour()
                            .withAlphaComponent(0.3)
                    }
                }
        }
    }
}
