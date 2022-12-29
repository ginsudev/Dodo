//
//  StatusImage.swift
//  
//
//  Created by Noah Little on 28/12/2022.
//

import SwiftUI

struct StatusImage: View {
    @EnvironmentObject var dimensions: Dimensions
    let image: Image
    let color: Color?
    
    init(image: Image, color: Color? = nil) {
        self.image = image
        self.color = color
    }
    
    var body: some View {
        image
            .renderingMode(color == nil ? .original : .template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: dimensions.statusItemHeight,
                height: dimensions.statusItemHeight
            )
            .foregroundColor(color)
    }
}

struct StatusImage_Previews: PreviewProvider {
    static var previews: some View {
        StatusImage(image: Image(systemName: "trash"))
    }
}
