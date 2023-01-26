//
//  Shape+Extension.swift
//  
//
//  Created by Noah Little on 26/1/2023.
//

import SwiftUI

extension Shape {
    func fill
    <
        Fill: ShapeStyle,
        Stroke: ShapeStyle
    >(
        _ fillStyle: Fill,
        strokeBorder strokeStyle: Stroke,
        lineWidth: Double = 1.0
    ) -> some View {
        self
            .stroke(
                strokeStyle,
                lineWidth: lineWidth
            )
            .background(self.fill(fillStyle))
    }
}
