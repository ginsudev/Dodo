//
//  StatusItemView.swift
//  
//
//  Created by Noah Little on 8/1/2023.
//

import SwiftUI

// MARK: - Public

struct StatusItemView: View, Identifiable {
    enum ItemStyle {
        case text(String)
        case image(String)
        case expanding(text: String, image: String)
    }
    
    @State var id = UUID().uuidString
    @State private var isExpanded = false
    
    var isReallyExpanded: Bool {
        isExpanded && isEnabledExpansion
    }
    
    private let settings = PreferenceManager.shared.settings
    private let isEnabled: Bool
    private let isEnabledExpansion: Bool
    private let style: ItemStyle
    private let tint: UIColor
    private let onTapAction: (() -> Void)?
    private let onLongHoldAction: (() -> Void)?
        
    init(
        isEnabled: Bool = true,
        isEnabledExpansion: Bool = false,
        style: ItemStyle,
        tint: UIColor,
        onTapAction: (() -> Void)? = nil,
        onLongHoldAction: (() -> Void)? = nil
    ) {
        self.isEnabled = isEnabled
        self.isEnabledExpansion = isEnabledExpansion
        self.style = style
        self.tint = tint
        self.onTapAction = onTapAction
        self.onLongHoldAction = onLongHoldAction
    }
    
    var body: some View {
        if isEnabled {
            Button {} label: {
                buttonLabel
                    .background(backgroundView)
                    .fixedSize()
            }
            .onReceive(NotificationCenter.default.publisher(for: .collapseStatusItems)) { notif in
                guard let id = notif.object as? String, id != self.id else { return }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    isExpanded = false
                }
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
                if isReallyExpanded {
                    textView(string: string)
                }
            }
            .padding(.horizontal, isReallyExpanded ? 7 : 0)
        }
    }
    
    var buttonLabel: some View {
        itemView
            .onTapGesture {
                if case .expanding = style, isEnabledExpansion {
                    expand()
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
    
    @ViewBuilder
    var backgroundView: some View {
        if case .expanding = style, isReallyExpanded {
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
    
    func imageView(name: String) -> some View {
        Image(systemName: name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(
                idealWidth: settings.statusItems.statusItemSize.width,
                idealHeight: settings.statusItems.statusItemSize.height
            )
            .scaleEffect(isReallyExpanded ? 0.7 : 1.0)
            .foregroundColor(isReallyExpanded ? Color(tint.suitableForegroundColour()) : Color(tint))
    }
    
    func textView(string: String) -> some View {
        Text(string)
            .foregroundColor(Color(tint.suitableForegroundColour()))
            .font(.system(.caption2, design: settings.appearance.selectedFont.representedFont))
            .fixedSize(horizontal: true, vertical: false)
            .lineLimit(1)
    }
    
    func expand() {
        if !isExpanded {
            // Collapse all other items before expanding this one.
            NotificationCenter.default.post(name: .collapseStatusItems, object: id)
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            isExpanded.toggle()
        }
    }
}
