//
//  AppView.swift
//  
//
//  Created by Noah Little on 19/11/2022.
//

import SwiftUI

//MARK: - Public

struct AppView: View {
    private var columns: [GridItem] {
        return [GridItem(
            .adaptive(
                minimum: 30,
                maximum: 40
            ),
            spacing: 5,
            alignment: .bottomTrailing
        )]
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(AppsManager.favouriteAppBundleIdentifiers, id: \.self) { identifier in
                        Button {
                            AppsManager.openApplication(withIdentifier: identifier)
                        } label: {
                            Image(uiImage: UIImage(withBundleIdentifier: identifier))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                Spacer()
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
