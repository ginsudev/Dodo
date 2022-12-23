//
//  Dimensions.swift
//  
//
//  Created by Noah Little on 21/12/2022.
//

import UIKit

final class Dimensions: ObservableObject {
    static let shared = Dimensions()
    @Published var isLandscape: Bool = false
}
