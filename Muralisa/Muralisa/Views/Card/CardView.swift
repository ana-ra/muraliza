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

enum BottomElement {
    case status
    case route
    case none
}

struct CardView: View {
    var colaborationViewModel: ColaborationViewModel
    
    @State private var tags: [String] = ["tapirus", "vapo", "tanguen"]
    
    @State private var showTagsModal: Bool = false
    @State private var showAlert: Bool = false
    @State var showCloseButton: Bool
    //    @State var showSeeRoutes: Bool
    var showBottomElement: BottomElement
    
    @Binding var showCard: Bool
    
    
    var body: some View {
        
        VStack {
            
            HStack{
                Spacer()
                if showCloseButton {
                    Button {
                        showCard.toggle()
                    }label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.thinMaterial)
                    }
                }
            }.padding(.vertical, 24)
                .padding(.horizontal, 16)
            
            
            if let image = colaborationViewModel.image {
                Image(uiImage: image)
                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: getWidth() - 80)
                    .cornerRadius(12)
                //                    .padding(.top, 16)
                    .padding(.bottom, 24)
                //                    .clipped()
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
            
            //if showBottomElement == .none {
                //
                
                switch showBottomElement {
                case .status:
                    StatusComponent(status: 1)
                        .padding(.bottom, 24)
                case .route:
                    Button {
                        print("Teste")
                    } label: {
                        Text("Ver rotas")
                    }
                    .padding(.bottom, 24)
                case .none:
                    EmptyView()
                }
                
            }.foregroundStyle(.white)
                .frame(width: getWidth() - 32)
                .frame(maxHeight: getHeight()*577/873)
                .background(
                    ZStack {
                        Rectangle()
                        //                        .frame(width: getWidth(), height: getHeight())
                            .foregroundStyle(.brandingSecondary)
                        Image("cardBackground")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.accent)
                    }.cornerRadius(32)
                )
            
        }
    }
    
    
    #Preview {
        let colaborationViewModel = ColaborationViewModel()
        CardView(colaborationViewModel: colaborationViewModel, showCloseButton: true, showBottomElement: .status, showCard: .constant(false))
            .onAppear {
                colaborationViewModel.image = UIImage(named: "ima")
                colaborationViewModel.title = "Crepusculo Nobre"
                colaborationViewModel.description = "shau hs auh ush uash uahs uash uahs ua"
                
            }
    }
