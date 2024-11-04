//
//  ColaborationView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct ColaborationView: View {
    
    // Substituir por dados salvos no userDefaults/coreData das obras colaboradas, o status deve vir da variável de controle no banco de dados.
    var works: [(String, Int, UUID)] = [("Bomb rua 2", 1, UUID()), ("Untitled", 0, UUID()), ("Grafite colorido", 2, UUID()), ("Wild hardcore", 0, UUID()), ("Bomb rua ", 2, UUID())]
    
    @State private var showingOptions = false
    
    @State private var showImagePicker: Bool = false
    @State private var showCamera: Bool = false
    
    @State private var pickerItem: PhotosPickerItem?
    
    @State private var location: CLLocation?
    @State private var selectedImage: UIImage?
    
    @State private var navigateToNewWork: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                
                if works.isEmpty {
                    Spacer()
                        .listRowBackground(Color.clear)
                }
                
                Section {
                    
                    if works.isEmpty {
                        Text("Você ainda não possui obras adicionadas à nossa curadoria de imagens.")
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, -16)
                    }
                    
                    
                    // Placeholder for ilustration
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: getHeight() / 3.5)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, -16)
                        .foregroundStyle(Color.gray)
                        .opacity(0.5)
                
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "photo.badge.plus")
                            .foregroundStyle(Color.accentColor)
                            .font(.largeTitle)
                            .onTapGesture {
                                showingOptions = true
                                
                            }
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
                                        selectedImage = UIImage(data: data)
                                        
                                        if let image = CIImage(data: data) {
                                            
                                            let properties = image.properties
                                            
                                            if let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
                                                let lat = gps[kCGImagePropertyGPSLatitude as String] as! Double
                                                let lon = gps[kCGImagePropertyGPSLongitude as String] as! Double
                                                
                                                location = CLLocation(latitude: lat, longitude: lon)
                                                
                                            }
                                        }
                                        self.navigateToNewWork = true
                                        return
                                    }
                                }
                            }
                            .fullScreenCover(isPresented: $showCamera) {
                                AccessCameraView(selectedImage: self.$selectedImage, navigate: self.$navigateToNewWork)
                                    .background(.black)
                            }
                        
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    HStack {
                        Text("Clique para colaborar com uma obra para a nossa curadoria de imagens")
                            .font(.body)
                            .foregroundStyle(Color.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .listRowBackground(Color.clear)
                    
                }
                .listRowSeparator(.hidden)
                
                if !works.isEmpty {
                    RecentlyAddedSection(works: works)
                        .listSectionSeparator(.hidden)
                } else {
                    Spacer()
                        .listRowBackground(Color.clear)
                }
                
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Colaborar")
            .navigationDestination(isPresented: $navigateToNewWork) {
                NewWorkView(image: selectedImage, location: location)
            }
        }
    }
}

#Preview {
    ColaborationView()
}
