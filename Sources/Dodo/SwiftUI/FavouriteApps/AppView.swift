//
//  AppView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct AppView: View {
    var body: some View {
        HStack {
            appsView
                .frame(alignment: .trailing)
        }
    }
}

//MARK: - Private

private extension AppView {
    var appsView: some View {
        ForEach(AppsManager.favouriteAppBundleIdentifiers, id: \.self) { identifier in
            Button {
                AppsManager.openApplication(withIdentifier: identifier)
            } label: {
                Image(uiImage: UIImage(withBundleIdentifier: identifier))
                    .resizable()
                    .frame(minWidth: 30, maxWidth: 40, minHeight: 30, maxHeight: 40)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
