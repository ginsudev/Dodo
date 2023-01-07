//
//  AlarmView.swift
//  
//
//  Created by Noah Little on 7/1/2023.
//

import SwiftUI

struct AlarmView: View {
    @Environment(\.openURL) private var openURL
    @Namespace private var namespace
    @State private var isExpanded = false
    
    let alarm: Alarm
    
    var body: some View {
        Button {
            withAnimation(.easeOut) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                if isExpanded {
                    alarmIcon
                        .frame(maxHeight: 10)
                        .foregroundColor(.black)
                        .matchedGeometryEffect(id: "alarmIcon", in: namespace)
                } else {
                    alarmIcon
                        .frame(maxHeight: 18)
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "alarmIcon", in: namespace)
                }
                alarmText
            }
            .padding(.horizontal, isExpanded ? 7 : 0)
        }
        .frame(height: 18)
        .background(isExpanded ? RoundedRectangle(cornerRadius: 9).foregroundColor(Color.white.opacity(0.7)) : nil)
        .fixedSize(horizontal: true, vertical: !isExpanded)
    }
}

private extension AlarmView {
    var alarmIcon: some View {
        Image(systemName: "alarm.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    var alarmText: some View {
        Text(isExpanded ?
            TimeDateView.ViewModel.shared.getDate(
                fromTemplate: .time,
                date: alarm.nextFireDate
            ) : ""
        )
        .foregroundColor(.black)
        .font(.system(size: 12, weight: .regular, design: PreferenceManager.shared.settings.fontType))
    }
}
