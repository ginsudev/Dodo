//
//  Created by Alexey Bukhtin on 26/03/2021.
//

import SwiftUI

extension View {
    
    /// Reads the view frame and bind it to the reader.
    /// - Parameters:
    ///   - coordinateSpace: a coordinate space for the geometry reader.
    ///   - reader: a reader of the view frame.
    func readFrame(in coordinateSpace: CoordinateSpace = .global,
                   for reader: Binding<CGRect>) -> some View {
        readFrame(in: coordinateSpace) { value in
            reader.wrappedValue = value
        }
    }
    
    /// Reads the view frame and send it to the reader.
    /// - Parameters:
    ///   - coordinateSpace: a coordinate space for the geometry reader.
    ///   - reader: a reader of the view frame.
    func readFrame(in coordinateSpace: CoordinateSpace = .global,
                   for reader: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(
                        key: FramePreferenceKey.self,
                        value: geometryProxy.frame(in: coordinateSpace)
                    )
                    .onPreferenceChange(FramePreferenceKey.self, perform: reader)
            }
        )
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue = CGRect.zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
