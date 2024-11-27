//
//  NewWorkCardView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 05/11/24.
//

import SwiftUI
import WrappingHStack
import CoreLocation
import CloudKit
import SwiftData

struct ReviewNewWorkView: View {
    
    @Environment(ColaborationRouter.self) var router
    
    var colaborationViewModel: ColaborationViewModel
    
    let workService = WorkService()
    let artistService = ArtistService()
    
    
    @State private var tags: [String] = []
    
    @State private var showTagsModal: Bool = false
    @State private var showAlert: Bool = false
    
    @Query var user: [User]
    
    
    var body: some View {
        VStack {
            CardView(image: colaborationViewModel.image, artist: colaborationViewModel.artist, title: colaborationViewModel.title, description: colaborationViewModel.description, tags: $tags, showCloseButton: false, showBottomElement: .none, showCard: .constant(true))
//            VStack {
//                if let image = colaborationViewModel.image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(maxWidth: getWidth() - 80)
//                        .cornerRadius(12)
//                        .padding(.top, 24)
//                        .padding(.bottom, 24)
//                        .clipped()
//                }
//                
//                HStack {
//                    Text("Artista:")
//                    Text(colaborationViewModel.artist == "" ? "Desconhecido" : colaborationViewModel.artist)
//                        .bold()
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 24)
//                .padding(.bottom, 16)
//                
//                
//                HStack {
//                    
//                    Text("Título:")
//                    Text(colaborationViewModel.title)
//                        .bold()
//                    Spacer()
//                }
//                .padding(.horizontal, 24)
//                .padding(.bottom, 16)
//                
//                
//                
//                
//                WrappingHStack(alignment: .leading) {
//                    
//                    Text("Descrição:")
//                    Text(colaborationViewModel.description == "" ? "Sem descrição" : colaborationViewModel.description)
//                        .bold()
//                        .lineLimit(1)
//                }
//                .padding(.horizontal, 24)
//                .padding(.bottom, tags.isEmpty ? 24 : 16)
//                
//                if !tags.isEmpty {
//                    
//                    
//                    HStack(spacing: 24) {
//                        
//                        ForEach(tags, id: \.self) { tag in
//                            
//                            Text("\(tag)")
//                                .font(.subheadline)
//                                .foregroundStyle(Color.white)
//                                .frame(width: (getWidth() - (32 + 48 + 48)) / 3)
//                                .padding(.vertical, 8)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .foregroundStyle(Color.white)
//                                        .opacity(0.25)
//                                )
//                        }
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.bottom, 24)
//                }
//                
//            }.foregroundStyle(.white)
//            .frame(width: getWidth() - 32)
//            .frame(maxHeight: getHeight()*4/7)
//            .background(
//                ZStack {
//                    
//                    Image("cardBackground")
//                        .resizable()
//                        .cornerRadius(32)
//                }
//            )
////            .padding(.vertical, 8)
            
            
            HStack {
                Spacer()
                Text("Adicione uma tag para enviar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }.padding(.top, 16)
            
            HStack {
                Spacer()
                Button {
                    showTagsModal = true
                } label: {
                    Text("Adicionar Tag")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundStyle(.gray)
                                .opacity(0.15)
                        )
                }
                .sheet(isPresented: $showTagsModal) {
                    AddTagsSheet(selectedTags: $tags)
                }
                
                Spacer()
            }
            .padding(.bottom, 12)
            
            
            HStack {
                Spacer()
                Button {
                    colaborationViewModel.getArtistID(artistName: [colaborationViewModel.artist])
                    colaborationViewModel.compressImage()
                    
                    Task {
                        do {
                            let workRecord = try await workService.saveWork(title: colaborationViewModel.title, workDescription: colaborationViewModel.description, tag: tags, image: colaborationViewModel.image, imageThumb: colaborationViewModel.imageThumb, location: colaborationViewModel.location!, artistReference: colaborationViewModel.artistsID)
                            
                            
                            //Saves new contribution to user local persistence
                            if let workRecord = workRecord, let user = user.first {
                                                                
                                if let contributionsId = user.contributionsId {
                                    print("contributionsId", contributionsId)
                                    var newContributionsId = contributionsId
                                    newContributionsId.append(workRecord.recordID.recordName)
                                    self.user.first?.contributionsId = newContributionsId
                                } else {
                                    self.user.first?.contributionsId = [workRecord.recordID.recordName]
                                }
                            }
                            
                            if let workRecord {
                                try await artistService.addWorkReferenceToArtists(colaborationViewModel.artistsID, workRecord: workRecord)
                            }
                        } catch {
                            print("error: \(error.localizedDescription)")
                        }
                    }
                    
                    router.navigateTo(route: .newWorkLoadingView)
                } label: {
                    Label("Enviar", systemImage: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.accentColor)
                        )
                }
                .disabled(tags.isEmpty)
                Spacer()
            }
            
            Spacer()
            
        }
        .padding(.top, 8)
        .navigationTitle("Revisar")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        let colaborationViewModel = ColaborationViewModel()
        ReviewNewWorkView(colaborationViewModel: colaborationViewModel)
            .environment(ColaborationRouter())
            .onAppear(){
                colaborationViewModel.image = UIImage(named: "ima")
                colaborationViewModel.description = "descripiton askdjfhlkajslhdfkjlasdklfaskhfalkjhsdkjfha"
                colaborationViewModel.title = "title"
            }
    }
}
