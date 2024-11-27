//
//  ProfileCardSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 22/11/24.
//

import SwiftUI

struct ProfileCardSubview: View {
    
    @Binding var approvedWorks: Int
    @Binding var pendingWorks: Int
    @Binding var rejectedWorks: Int
    
    @State var title: String
    
    var totalWorks: Int {
        approvedWorks + pendingWorks + rejectedWorks
    }
    
    var body: some View {

            VStack {
                HStack {
                    Text("\(totalWorks) Obras adicionadas")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(Image(systemName: "asterisk")) \(Image(systemName: "asterisk")) \(Image(systemName: "asterisk"))")
                        .font(.caption2)
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 8)
                
                HStack {
                    Text("\(title)")
                        .font(.caption)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                HStack {
                    
                    VStack(alignment: .center) {
                        Text("\(approvedWorks)")
                            .font(.headline)
                        Text("aprovadas")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("\(pendingWorks)")
                            .font(.headline)
                        Text("pendentes")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("\(rejectedWorks)")
                            .font(.headline)
                        Text("rejeitadas")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 18)
            }
            .listRowBackground(
                ZStack {
                    Rectangle()
                        .foregroundStyle(.brandingSecondary)
                    Image(.profileCardBackground)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFill()
                        .foregroundStyle(.stripesCard)
                }
            )
        }
}


#Preview {
    Form {
        ProfileCardSubview(approvedWorks: .constant(789), pendingWorks: .constant(112), rejectedWorks: .constant(948), title: "Art hunter")
    }
}
