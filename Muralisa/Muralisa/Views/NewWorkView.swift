//
//  NewWorkView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 01/11/24.
//

import SwiftUI
import CoreLocation
import PhotosUI

struct NewWorkView: View {
    
    @Environment(\.presentationMode) var isPresented
    
    @StateObject var vm = ColaborationViewModel()
    
    @State var artists: [String] = []
    
    @State var image: UIImage?
    @State var location: CLLocation?
    
    @State private var artist: String = ""
    
    @State private var title: String = ""
    @State private var description: String = ""
    
    @State private var showingOptions: Bool = false
    
    @State private var pickerItem: PhotosPickerItem?
    
    @State private var showImagePicker: Bool = false
    @State private var showCamera: Bool = false
    
    @State private var navigate: Bool = false
    
    var body: some View {
        List {
            Section {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: getHeight()/3)
                        .frame(width: getWidth() - 16)
                        .padding(.horizontal, -16)
                        .cornerRadius(20)
                        .listRowBackground(Color.clear)
                }
            }
            
            Section {
                HStack {
                    HStack {
                        Text("Artista")
                        Spacer()
                    }
                    .frame(width: 100)
                    
                    TextField("Desconhecido", text: $artist)
                }
            }
            
            Section {
                HStack {
                    HStack {
                        Text("Título")
                        Spacer()
                    }
                    .frame(width: 100)
                    
                    TextField("Sem título", text: $title)
                }
                
                HStack {
                    HStack {
                        Text("Descrição")
                        Spacer()
                    }
                    .frame(width: 100)
                    
                    TextField("Opcional", text: $description)
                }
            } header: {
                Text("Sobre a obra")
            }
            
            
            Section {
                HStack {
                    Spacer()
                    Text("Revisar")
                        .foregroundStyle(title.isEmpty ? Color.secondary : .white)
                        .padding(.horizontal)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(title.isEmpty ? .gray : .accent)
                                .opacity(title.isEmpty ? 0.25 : 1)
                        )
                        .onTapGesture {
                            if !title.isEmpty {
                                navigate = true
                            }
                        }
                    Spacer()
                }
                .listRowBackground(Color.clear)

                
                HStack {
                    Spacer()
                    Text("Tirar outra foto")
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            showingOptions = true
                        }
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .confirmationDialog("Adicionar foto à curadoria", isPresented: $showingOptions, titleVisibility: .visible) {
                    Button("Camera")  {
                        showCamera = true
                    }
                    Button("Galeria de fotos") {
                        showImagePicker = true
                    }
                }
                .photosPicker(isPresented: $showImagePicker, selection: $pickerItem, matching: .images, photoLibrary: .shared())
                .onChange(of: pickerItem) {
                    Task {
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                            
                            if let image = CIImage(data: data) {
                                
                                let properties = image.properties
                                
                                if let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
                                    let lat = gps[kCGImagePropertyGPSLatitude as String] as! Double
                                    let lon = gps[kCGImagePropertyGPSLongitude as String] as! Double
                                    
                                    location = CLLocation(latitude: lat, longitude: lon)
                                    
                                }
                            }
                            return
                        }
                    }
                }
                .fullScreenCover(isPresented: $showCamera) {
                    AccessCameraView(selectedImage: self.$image, navigate: .constant(true))
                        .background(.black)
                }
            }
        }
        .listSectionSpacing(16)
        .navigationTitle("Editar")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancelar") {
                    isPresented.wrappedValue.dismiss()
                }
            }
        }
        .task {
            do {
                try await vm.fetchArtists()
            } catch {
                print("deu erro \(error.localizedDescription)")
            }
        }
        .navigationDestination(isPresented: $navigate) {
            NewWorkCardView(artist: artist, title: title, descripition: description, image: image, location: location)
        }
    }
}


#Preview {
    NewWorkView(image: UIImage(named: "ima"), location: CLLocation(latitude: -24, longitude: 48))
}
