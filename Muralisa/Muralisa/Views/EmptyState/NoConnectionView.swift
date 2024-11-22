//
//  DisabledLocationView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 01/11/24.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            // Illustration will be here in the future
            Image(.noInternetConnection)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(.brandingSecondary)
                .opacity(0.4)
            
          
            Text("Você está sem conexão com a internet")
                .foregroundStyle(.secondary)
                .font(.body)
                .bold()
                .padding(.bottom, -16)
            
            Text("Habilite para consumir e colaborar com obras de arte urbana.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    NoConnectionView()
}
