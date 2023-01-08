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
    let customSize: CGSize
    
    init(
        image: Image,
        color: Color? = nil,
        customSize: CGSize = Dimensions.shared.statusItemSize
    ) {
        self.image = image
        self.color = color
        self.customSize = customSize
    }
    
    var body: some View {
        image
            .renderingMode(color == nil ? .original : .template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                maxWidth: customSize.width,
                maxHeight: customSize.height
            )
            .foregroundColor(color)
    }
}

struct StatusImage_Previews: PreviewProvider {
    static var previews: some View {
        StatusImage(image: Image(systemName: "trash"))
    }
}
