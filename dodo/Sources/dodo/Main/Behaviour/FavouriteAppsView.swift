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
                Toggle(Copy.enabled, isOn: $preferenceStorage.hasFavouriteApps)
            } footer: {
                Text(Copy.favouriteAppsOnLS)
            }

            Group {
                Section {
                    AppPicker(selectedAppIdentifiers: $preferenceStorage.selectedFavouriteApps, title: Copy.apps, visibleApplicationGroup: .all)
                } footer: {
                    Text(Copy.selectYourApps)
                }
                
                layoutSection
                
                Section {
                    Toggle(isOn: $preferenceStorage.isVisibleFavouriteAppsFade) {
                        SubtitleText(title: Copy.showFade, subtitle: Copy.showFadeDesc)
                    }
                } header: {
                    Text(Copy.misc)
                }
            }
            .disabled(!preferenceStorage.hasFavouriteApps)
        }
        .navigationTitle(Copy.favouriteApps)
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
            Picker(Copy.gridType, selection: $preferenceStorage.favouriteAppsGridSizeType.animation()) {
                ForEach(GridSizeType.allCases, id: \.rawValue) {
                    Text($0.title)
                        .tag($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .flexible {
                Stepper(value: $preferenceStorage.favouriteAppsFlexibleGridItemSize, in: 10.0...100.0) {
                    SubtitleText(
                        title: Copy.flexibleItemSize,
                        subtitle: "\(preferenceStorage.favouriteAppsFlexibleGridItemSize)"
                    )
                }
            } else if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .fixed {
                Stepper(value: $preferenceStorage.favouriteAppsFixedGridItemSize, in: 10.0...60.0) {
                    SubtitleText(
                        title: Copy.fixedItemSize,
                        subtitle: "\(preferenceStorage.favouriteAppsFixedGridItemSize)"
                    )
                }
            }
            
            if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .flexible {
                Stepper(value: $preferenceStorage.favouriteAppsFlexibleGridColumnAmount, in: 1...8) {
                    SubtitleText(
                        title: Copy.flexibleColumnAmount,
                        subtitle: "\(preferenceStorage.favouriteAppsFlexibleGridColumnAmount)"
                    )
                }
            } else if GridSizeType(rawValue: preferenceStorage.favouriteAppsGridSizeType) == .fixed {
                Stepper(value: $preferenceStorage.favouriteAppsFixedGridColumnAmount, in: 1...3) {
                    SubtitleText(
                        title: Copy.fixedColumnAmount,
                        subtitle: "\(preferenceStorage.favouriteAppsFixedGridColumnAmount)"
                    )
                }
            }
        } header: {
            Text(Copy.layout)
        } footer: {
            Text(Copy.layoutFooter)
        }
    }
}

struct FavouriteAppsView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAppsView()
    }
}
