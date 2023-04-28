//
//  StatusItemView.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import SwiftUI

// MARK: - Public

struct StatusItemView<Content: View>: View {
    let text: String?
    let tint: UIColor
    @ViewBuilder let content: Content
    let onTapAction: (() -> Void)?
    let onLongHoldAction: (() -> Void)?
    
    @EnvironmentObject var dimensions: Dimensions
    @Namespace private var namespace
    @State private var isExpanded = false
    
    init(
        text: String? = nil,
        tint: UIColor,
        @ViewBuilder content: @escaping () -> Content,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) {
        self.text = text
        self.tint = tint
        self.content = content()
        self.onTapAction = onTapAction
        self.onLongHoldAction = onLongHoldAction
    }
    
    var body: some View {
        if text == nil {
            button
        } else {
            button
                .background(backgroundView)
        }
    }
}

// MARK: - Private

private extension StatusItemView {
    @ViewBuilder
    var backgroundView: some View {
        if isExpanded {
            RoundedRectangle(cornerRadius: 9)
                .fill(Color(tint).opacity(0.7))
        }
    }
    
    var button: some View {
        Button {} label: {
            buttonLabel
                .fixedSize(horizontal: true, vertical: true)
                .onTapGesture {
                    if text != nil {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
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
        HStack(spacing: 2.0) {
            if isExpanded {
                content
                    .statusItem()
                    .foregroundColor(Color(tint.suitableForegroundColour()))
                    .scaleEffect(0.7)
                    .matchedGeometryEffect(id: "statusIcon", in: namespace)
            } else {
                content
                    .statusItem()
                    .foregroundColor(Color(tint))
                    .scaleEffect(1.0)
                    .matchedGeometryEffect(id: "statusIcon", in: namespace)
            }
            textView
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
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
                        size: 12.0,
                        design: PreferenceManager.shared.settings.selectedFont.representedFont
                    )
                )
        }
    }
}
