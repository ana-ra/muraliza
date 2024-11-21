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
    //var colaborationViewModel: ColaborationViewModel
    @StateObject var locationManager = LocationManager()
    let locationService = LocationService()
    
    var image: UIImage?
    
    var artist: String
    var title: String
    var description: String
    var location: CLLocation?
    
    @Binding var tags: [String]
    @State var showCloseButton: Bool
    //    @State var showSeeRoutes: Bool
    var showBottomElement: BottomElement
    
    @Binding var showCard: Bool
    
    @State private var dialogDetail: (URL?, URL?)
    @State private var hasRoute: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                if showCloseButton {
                    Button {
                        showCard.toggle()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.thinMaterial)
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            
            if let image = image {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: getWidth() - 80)
                        .frame(height: getHeight() / 3.8)
                        .cornerRadius(12)
                        .padding(.bottom, 24)
                }
            }
            
            HStack {
                Text("Artista:")
                Text(artist == "" ? "Desconhecido" : artist)
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            
            HStack {
                Text("Título:")
                Text(title)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            WrappingHStack(alignment: .leading) {
                Text("Descrição:")
                Text(description == "" ? "Sem descrição" : description)
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
                            .padding(8)
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
            
            switch showBottomElement {
            case .status:
                StatusComponent(status: 1)
                    .padding(.bottom, 24)
            case .route:
                Button {
                    if let location = locationManager.location, let workLocation = self.location {
                        dialogDetail = locationService.getMapsLink(from: location, to: workLocation)
                        hasRoute = true
                    }
                } label: {
                    Text("Ver rotas")
                }
                .padding(.bottom, 24)
                .confirmationDialog("Abrir no Maps", isPresented: $hasRoute, titleVisibility: .visible, presenting: dialogDetail) { links in
                    if let appleMapsLink = links.0 {
                        Button {
                            UIApplication.shared.open(appleMapsLink)
                        } label: {
                            Text("Maps")
                        }
                    }
                    
                    if let googleMapsLink = links.1 {
                        Button {
                            UIApplication.shared.open(googleMapsLink)
                        } label: {
                            Text("Google Maps")
                        }
                    }
                } message: { _ in
                    Text("Qual app você gostaria de utilizar?")
                }
            case .none:
                EmptyView()
            }
            
        }
        .foregroundStyle(.white)
        .frame(width: getWidth() - 32)
        .frame(maxHeight: getHeight()*577/873)
        .background(
            ZStack {
                Rectangle()
                    .foregroundStyle(.brandingSecondary)
                Image("cardBackground")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.stripesCard)
            }
            .cornerRadius(32)
        )
    }
}


#Preview {
    CardView(image: UIImage(named: "ima"), artist: "", title: "Crepusculo Nobre", description: "asdfh asdhf ashdf asdfh", tags: .constant(["Teste 1", "Teste 2"]), showCloseButton: true, showBottomElement: .status, showCard: .constant(false))
    
}
