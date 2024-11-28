//
//  Onboarding1.swift
//  Muralisa
//
//  Created by Anderson  Vulto on 28/11/24.
//

import SwiftUI

struct OnboardingContent: View {
    @Binding var showOnboarding: Bool
    var sfSymbol: String
    var titleText: String
    var descriptionText: String
    var button: Bool
    @State var disabled: Bool = false
    var body: some View {
        VStack(spacing: 16){
            Text(Image(systemName: sfSymbol))
                .font(.title).bold()
            Text(titleText)
                .font(.title).bold()
                .multilineTextAlignment(.center)
            Text(descriptionText)
                .multilineTextAlignment(.center)
            
            if button{
                Button {
                    showOnboarding.toggle()
                } label: {
                    Text("Muralizar")
                        .frame(width: getWidth()*0.75)
                }.buttonStyle(.borderedProminent)
                    .padding(.vertical, 40)
                    .padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    OnboardingContent(showOnboarding: $showOnboarding,sfSymbol: "linewidth.circle.fill", titleText: "Title", descriptionText: "Description", button: true)
//}
