//
//  MarqueeText.swift
//  
//
//  Created by Noah Little on 18/2/2023.
//

import SwiftUI

struct MarqueeText: UIViewRepresentable {
    let text: String
    let color: UIColor
    let font: UIFont
    let rate: CGFloat
    let fadeLength: CGFloat
    let isScrollable: Bool

    func makeUIView(context: Context) -> MarqueeLabel {
        let label = MarqueeLabel(
            frame: .zero,
            rate: rate,
            fadeLength: fadeLength
        )
        label.trailingBuffer = 20.0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        updateUIView(label, context: context)
        return label
    }

    func updateUIView(_ uiView: MarqueeLabel, context: Context) {
        uiView.text = text
        uiView.textColor = color
        uiView.font = font
        uiView.preferredMaxLayoutWidth = .infinity
        uiView.labelize = !isScrollable
    }
}
