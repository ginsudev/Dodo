//
//  FavouriteAppsView.swift
//  
//
//  Created by Noah Little on 22/4/2023.
//

import SwiftUI
import Comet
import GSCore

// MARK: - Internal

struct FavouriteAppsView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    
    var body: some View {
        Form {
            Section {
                Toggle("Enabled", isOn: $preferenceStorage.hasFavouriteApps)
            } footer: {
                Text("Show your favourite apps on the lock screen.")
            }

            Group {
                Section {
                    AppPicker(selectedAppIdentifiers: $preferenceStorage.selectedFavouriteApps, title: "Apps", visibleApplicationGroup: .all)
                } footer: {
                    Text("Select your apps")
                }
                
                layoutSection
                
                Section {
                    Toggle(isOn: $preferenceStorage.isVisibleFavouriteAppsFade) {
                        SubtitleText(title: "Show fade", subtitle: "Adds a subtle fade to the bottom of the app grid.")
                    }
                } header: {
                    Text("Misc")
                }
            }
            .disabled(!preferenceStorage.hasFavouriteApps)
        }
        .navigationTitle("Favourite apps")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AlertRespringButton()
            }
        }
    }
}

// MARK: - Private

private extension FavouriteAppsView {
    var layoutSection: some View {
        Section {
            Picker("Grid type", selection: $preferenceStorage.favouriteAppsGridSizeType.animation()) {
                ForEach(GridSizeType.allCases, id: \.rawValue) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .flexible {
                Stepper(value: $preferenceStorage.favouriteAppsFlexibleGridItemSize, in: 10.0...100.0) {
                    SubtitleText(
                        title: "Flexible item size",
                        subtitle: "\(preferenceStorage.favouriteAppsFlexibleGridItemSize)"
                    )
                }
            } else if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .fixed {
                Stepper(value: $preferenceStorage.favouriteAppsFixedGridItemSize, in: 10.0...60.0) {
                    SubtitleText(
                        title: "Fixed item size",
                        subtitle: "\(preferenceStorage.favouriteAppsFixedGridItemSize)"
                    )
                }
            }
            
            if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .flexible {
                Stepper(value: $preferenceStorage.favouriteAppsFlexibleGridColumnAmount, in: 1...8) {
                    SubtitleText(
                        title: "Flexible column amount",
                        subtitle: "\(preferenceStorage.favouriteAppsFlexibleGridColumnAmount)"
                    )
                }
            } else if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .fixed {
                Stepper(value: $preferenceStorage.favouriteAppsFixedGridColumnAmount, in: 1...3) {
                    SubtitleText(
                        title: "Fixed column amount",
                        subtitle: "\(preferenceStorage.favouriteAppsFixedGridColumnAmount)"
                    )
                }
            }
        } header: {
            Text("Layout")
        } footer: {
            Text("Configure sizing, dimensions, row and column count.")
        }
    }
}

struct FavouriteAppsView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAppsView()
    }
}
