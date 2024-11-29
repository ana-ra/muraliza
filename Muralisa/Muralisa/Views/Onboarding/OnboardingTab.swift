//
//  SwiftUIView.swift
//  Muralisa
//
//  Created by Anderson  Vulto on 28/11/24.
//

import SwiftUI

struct OnboardingTab: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showOnboarding: Bool
    var body: some View {
        
        let overlayBg = colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.2)
        VStack {
            TabView {
                OnboardingContent(showOnboarding: $showOnboarding, sfSymbol: "lineweight", titleText: "Receba sugestões diárias de arte urbana", descriptionText: "Explore outras obras baseadas em recomendações a partir do artista, de proximidades à obra e mais!", button: false).tag(0)
                OnboardingContent(showOnboarding: $showOnboarding, sfSymbol: "photo.badge.checkmark.fill", titleText: "Colabore com novas imagens!", descriptionText: "Envie novas artes e contribua com o movimento da arte de rua, alimentando nosso banco de imagens.", button: false).tag(1)
                OnboardingContent(showOnboarding: $showOnboarding, sfSymbol: "map.fill", titleText: "Explore as obras próximas a você", descriptionText: "Abra o nosso mapa para ter acesso às artes urbanas próximas a você e trace rotas para visitá-las!", button: false).tag(2)
                OnboardingContent(showOnboarding: $showOnboarding, sfSymbol: "person.3.fill", titleText: "Crie um perfil na nossa comunidade", descriptionText: "Isso te permitirá colaborar ativamente com as novas obras da nossa galeria de imagens.", button: true).tag(3)
            }.tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
        }
        .background {
            Color.accentColor
            Image(.curlsBackgroundPattern)
                .resizable()
                .scaledToFill()
                .opacity(colorScheme == .dark ? 1 : 0.4)
            Color(overlayBg)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingTab(showOnboarding: .constant(true))
}
