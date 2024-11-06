//
//  CustomProminentButtonStyle.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 31/10/24.
//

import SwiftUI

struct CustomBorderedProminentButtonStyle: ButtonStyle {
    let color: Color
    let isFullScreen: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: isFullScreen ? .infinity : nil)
            .padding(.vertical, 16)
            .padding(.horizontal, isFullScreen ? 0 : 16)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
