//
//  StatusItemView.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import SwiftUI

struct StatusItemView: View {
    @EnvironmentObject var dimensions: Dimensions
    @Namespace private var namespace
    @State private var isExpanded = false
    
    let image: Image
    let tint: UIColor
    let text: String?
    let onTapAction: (() -> Void)?
    let onLongHoldAction: (() -> Void)?
    
    init(
        image: Image,
        tint: UIColor = .white,
        text: String? = nil,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) {
        self.image = image
        self.tint = tint
        self.text = text
        self.onTapAction = onTapAction
        self.onLongHoldAction = onLongHoldAction
    }
    
    var body: some View {
        if text == nil {
            button
        } else {
            button
                .background(
                    isExpanded
                    ? RoundedRectangle(cornerRadius: 9)
                        .foregroundColor(Color(tint).opacity(0.7))
                    : nil
                )
        }
    }
}

private extension StatusItemView {
    var button: some View {
        Button {} label: {
            buttonLabel
                .onTapGesture {
                    if text != nil {
                        withAnimation(.easeOut) {
                            isExpanded.toggle()
                        }
                    }
                    
                    if let onTapAction {
                        onTapAction()
                    }
                }
                .onLongPressGesture {
                    if let onLongHoldAction {
                        onLongHoldAction()
                    }
                }
        }
        .frame(height: dimensions.statusItemSize.height)
    }
    
    var buttonLabel: some View {
        HStack {
            if isExpanded {
                StatusImage(
                    image: image,
                    color: Color(tint.suitableForegroundColour()),
                    customSize: CGSize(
                        width: 10,
                        height: 10
                    )
                )
                .matchedGeometryEffect(id: "statusIcon", in: namespace)
            } else {
                StatusImage(
                    image: image,
                    color: Color(tint)
                )
                .matchedGeometryEffect(id: "statusIcon", in: namespace)
            }
            textView
        }
        .padding(.horizontal, isExpanded ? 7 : 0)
    }
    
    @ViewBuilder
    var textView: some View {
        if let text, isExpanded {
            Text(text)
            .foregroundColor(Color(tint.suitableForegroundColour()))
            .font(
                .system(
                    size: 12,
                    weight: .regular,
                    design: PreferenceManager.shared.settings.fontType
                )
            )
        }
    }
}
