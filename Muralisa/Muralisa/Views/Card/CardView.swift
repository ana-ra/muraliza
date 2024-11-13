//
//  CardView.swift
//  Muralisa
//
//  Created by Bruno Dias on 13/11/24.
//

import SwiftUI
import WrappingHStack
import CoreLocation
import CloudKit


struct CardView: View {
    var colaborationViewModel: ColaborationViewModel

    
    
    @State private var tags: [String] = ["sdasd"]
    
    @State private var showTagsModal: Bool = false
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        VStack {
            
            VStack {
                
                HStack{
                    Spacer()
                    
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.thinMaterial)
                        .padding()
                }.padding(.top, 24)
                
                
                if let image = colaborationViewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: getWidth() - 80)
                        .frame(maxHeight: tags.isEmpty ? getHeight()/3.2 : getHeight()/4.2)
                        .cornerRadius(20)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                        .clipped()
                }
                
                HStack {
                    Text("Artista:")
                    Text(colaborationViewModel.artist == "" ? "Desconhecido" : colaborationViewModel.artist)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                
                HStack {
                    
                    Text("Título:")
                    Text(colaborationViewModel.title)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                
                
                
                WrappingHStack(alignment: .leading) {
                    
                    Text("Descrição:")
                    Text(colaborationViewModel.description == "" ? "Sem descrição" : colaborationViewModel.description)
                        .bold()
                        .lineLimit(1)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, tags.isEmpty ? 24 : 16)
                
                if !tags.isEmpty {
                    
                    
                    HStack(spacing: 24) {
                        
                        ForEach(tags, id: \.self) { tag in
                            
                            Text("\(tag)")
                                .font(.subheadline)
                                .foregroundStyle(Color.white)
                                .frame(width: (getWidth() - (32 + 48 + 48)) / 3)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .foregroundStyle(Color.white)
                                        .opacity(0.25)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
            }.foregroundStyle(.white)
            .frame(width: getWidth() - 32)
            .frame(maxHeight: getHeight()/1.8)
            .background(
                ZStack {
                    
                    Image("cardBackground")
                        .resizable()
                        .cornerRadius(20)
                }
            )
            .padding(.vertical, 24)
            
            
            
            
            Spacer()
            
        }
    }
}

#Preview {
    let colaborationViewModel = ColaborationViewModel()
    CardView(colaborationViewModel: colaborationViewModel)
        .onAppear {
            colaborationViewModel.image = UIImage(named: "ima")
            colaborationViewModel.title = "Crepusculo Nobre"
            
        }
}
