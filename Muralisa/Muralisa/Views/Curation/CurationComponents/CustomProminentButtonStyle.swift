//
//  CustomProminentButtonStyle.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI

struct CustomBorderedProminentButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(10)
    }
}
