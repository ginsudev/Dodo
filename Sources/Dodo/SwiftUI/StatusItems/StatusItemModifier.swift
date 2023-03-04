//
//  StatusItemModifier.swift
//  
//
//  Created by Noah Little on 28/12/2022.
//

import SwiftUI

extension View {
    func statusItem(renderingMode: Image.TemplateRenderingMode = .template) -> some View {
        modifier(StatusItemModifier())
    }
}

struct StatusItemModifier: ViewModifier {
    @EnvironmentObject var dimensions: Dimensions

    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fit)
            .frame(
                width: dimensions.statusItemSize.width,
                height: dimensions.statusItemSize.height
            )
    }
}
