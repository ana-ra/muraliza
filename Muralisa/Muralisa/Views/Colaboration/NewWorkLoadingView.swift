//
//  NewWorkLoadingView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 02/11/24.
//

import SwiftUI
import CoreLocation

struct NewWorkLoadingView: View {
    @Environment(ColaborationRouter.self) var router
    
    var colaborationViewModel: ColaborationViewModel
    
    @State var currentStep: Int = 0
    @State private var timer: Timer?
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image(uiImage: colaborationViewModel.image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: getHeight() / 3)
                .frame(maxWidth: .infinity)
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    if currentStep < 1 {
                        ProgressView()
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.accent)
                    }
                    
                    Text("Validando colaboração")
                        .foregroundStyle(currentStep >= 1 ? .primary : .secondary)
                }
                
                HStack {
                    if currentStep < 2 {
                        ProgressView()
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.accent)
                    }
                    
                    Text("Fazendo upload da imagem")
                        .foregroundStyle(currentStep >= 2 ? .primary : .secondary)
                }
                
                HStack {
                    if currentStep < 3 {
                        ProgressView()
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.accent)
                    }
                    Text("Finalizando")
                        .foregroundStyle(currentStep >= 3 ? .primary : .secondary)
                }
            }
        }
        .progressViewStyle(.circular)
        .padding(16)
        .navigationBarBackButtonHidden()
        .navigationTitle("Enviar")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startProgression()
        }
        .alert("Muito obrigado por contribuir!", isPresented: $showAlert) {
            Button("Entendi") {
                router.navigateToRoot()
            }
        } message: {
            Text("Nosso time de curadoria está avaliando sua colaboração")
        }
    }
    
    // Repeats three times and then stops
    private func startProgression() {
        currentStep = 0
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            withAnimation {
                currentStep += 1
                if currentStep > 3 {
                    timer.invalidate()
                    self.timer = nil
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    NewWorkLoadingView(colaborationViewModel: ColaborationViewModel())
        .environment(ColaborationRouter())
}
