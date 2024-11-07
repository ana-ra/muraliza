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
            
            // Illustration will be here in the future
            Image(systemName: "location.slash")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.secondary)
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
