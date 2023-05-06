//
//  StatusItemView.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import SwiftUI

// MARK: - Public

struct StatusItemView: View {
    enum ItemStyle {
        case text(String)
        case image(String)
        case expanding(text: String, image: String)
    }
    
    @State private var isExpanded = false
    
    private let settings = PreferenceManager.shared.settings
    private let isEnabled: Bool
    private let style: ItemStyle
    private let tint: UIColor
    private let onTapAction: (() -> Void)?
    private let onLongHoldAction: (() -> Void)?
        
    init(
        isEnabled: Bool = true,
        style: ItemStyle,
        tint: UIColor,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) {
        self.isEnabled = isEnabled
        self.style = style
        self.tint = tint
        self.onTapAction = onTapAction
        self.onLongHoldAction = onLongHoldAction
    }
    
    var body: some View {
        if isEnabled || (settings.statusItems.isVisibleWhenDisabled && !isEnabled) {
            Button {} label: {
                buttonLabel
                    .background(backgroundView)
                    .fixedSize()
            }
        }
    }
}

// MARK: - Private

private extension StatusItemView {
    @ViewBuilder
    var itemView: some View {
        switch style {
        case let .text(string):
            textView(string: string)
                .frame(
                    idealWidth: settings.statusItems.statusItemSize.width,
                    idealHeight: settings.statusItems.statusItemSize.height
                )
        case let .image(imageName):
            imageView(name: imageName)
        case let .expanding(string, imageName):
            HStack {
                imageView(name: imageName)
                if isExpanded {
                    textView(string: string)
                }
            }
            .padding(.horizontal, isExpanded ? 7 : 0)
        }
    }
    
    var buttonLabel: some View {
        itemView
            .onTapGesture {
                if case .expanding = style {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                        isExpanded.toggle()
                    }
                } else if let onTapAction {
                    onTapAction()
                }
            }
            .onLongPressGesture {
                if let onLongHoldAction {
                    onLongHoldAction()
                }
            }
    }
    
    func imageView(name: String) -> some View {
        Image(systemName: name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(
                idealWidth: settings.statusItems.statusItemSize.width,
                idealHeight: settings.statusItems.statusItemSize.height
            )
            .scaleEffect(isExpanded ? 0.7 : 1.0)
            .foregroundColor(isExpanded ? Color(tint.suitableForegroundColour()) : Color(tint))
    }
    
    func textView(string: String) -> some View {
        Text(string)
            .foregroundColor(Color(tint.suitableForegroundColour()))
            .font(.system(.caption2, design: settings.appearance.selectedFont.representedFont))
            .fixedSize(horizontal: true, vertical: false)
            .lineLimit(1)
    }
    
    @ViewBuilder
    var backgroundView: some View {
        if case .expanding = style, isExpanded {
            Capsule()
                .fill(Color(tint).opacity(0.7))
        } else if case .text = style {
            Circle()
                .fill(Color(tint))
                .frame(
                    idealWidth: settings.statusItems.statusItemSize.width,
                    idealHeight: settings.statusItems.statusItemSize.height
                )
                .fixedSize()
        }
    }
}
