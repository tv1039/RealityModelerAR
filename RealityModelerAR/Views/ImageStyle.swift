//
//  ImageStyle.swift
//  RealityModelerAR
//
//  Created by 홍승표 on 6/7/24.
//

import SwiftUI

struct ImageStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension Image {
    func imageStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .tint(.primary)
            .padding()
    }
}

