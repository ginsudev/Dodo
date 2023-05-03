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
    func body(content: Content) -> some View {
        let size = PreferenceManager.shared.settings.statusItems.statusItemSize
        
        content
            .aspectRatio(contentMode: .fit)
            .frame(
                width: size.width,
                height: size.height
            )
    }
}
