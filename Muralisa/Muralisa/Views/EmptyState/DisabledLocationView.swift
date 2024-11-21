//
//  NoConnectionView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 01/11/24.
//

import SwiftUI

struct DisabledLocationView: View {
    @StateObject var locationManager: LocationManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            
            // Illustration will be here in the future
            Image(.locStencil)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(Color.brandingSecondary)
                .opacity(0.4)
            
            Text("Sua localização está desabilitada")
                .font(.body)
                .foregroundStyle(.secondary)
                .bold()
                .padding(.bottom, -16)
            
            Text("Sua localização está desabilitada. Para adicionar uma imagem, habilite-a em Configurações.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                if locationManager.authorizationStatus == .denied {
                    openAppSettings()
                } else {
                    locationManager.askPermission()
                }
            } label: {
                HStack {
                    Image(systemName: "gear")
                    Text("Configurações")
                }
            }
        }
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }

}

#Preview {
    DisabledLocationView(locationManager: LocationManager())
}
