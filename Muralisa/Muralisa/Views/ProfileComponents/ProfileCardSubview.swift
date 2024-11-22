//
//  ProfileCardSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 22/11/24.
//

import SwiftUI

struct ProfileCardSubview: View {
    
    @State var approvedWorks: Int
    @State var pendingWorks: Int
    @State var rejectedWorks: Int
    
    @State var title: String
    
    var totalWorks: Int {
        approvedWorks + pendingWorks + rejectedWorks
    }
    
    var body: some View {
        Section {
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
                .padding(.bottom, 24)
                
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
                .padding(.horizontal, 26)
                .padding(.bottom, 20)
            }
            .listRowBackground(Color.brandingSecondary)
        }
    }
}


#Preview {
    Form {
        ProfileCardSubview(approvedWorks: 789, pendingWorks: 112, rejectedWorks: 948, title: "Art hunter")
    }
}
