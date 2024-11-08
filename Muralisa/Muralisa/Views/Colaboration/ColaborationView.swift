//
//  ColaborationView.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI
import PhotosUI
import CoreLocation


enum ColaborationNavigationDestinations: String, CaseIterable, Hashable {
    case newWork
    case reviewNewWork
}

@Observable
class ColaborationRouter {
    var navigationPath = NavigationPath()
    
    func navigateTo(route: ColaborationNavigationDestinations) {
        navigationPath.append(route)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}

struct ColaborationView: View {
    
    @Environment(ColaborationRouter.self) var router
    
    @StateObject var colaborationViewModel = ColaborationViewModel()
    @State var locationManager = LocationManager()
    
    let screens = ColaborationNavigationDestinations.allCases
    
    // Substituir por dados salvos no userDefaults/coreData das obras colaboradas, o status deve vir da variável de controle no banco de dados.
    var works: [(String, Int, UUID)] = []
    
    @State private var showingOptions = false
    
    @State private var showImagePicker: Bool = false
    @State private var showCamera: Bool = false
    
    @State private var pickerItem: PhotosPickerItem?
    
    @State private var navigateFromCamera: Bool = false
    
    var body: some View {
        List {
            
            Section {
                
                if works.isEmpty {
                    Spacer()
                        .listRowBackground(Color.clear)
                }
                
                Section {
                    
                    if works.isEmpty {
                        Text("Você ainda não possui obras adicionadas à nossa curadoria de imagens.")
                            .listRowBackground(Color.clear)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, -16)
                            .foregroundStyle(.secondary)
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
                                    colaborationViewModel.location = locationManager.location
                                }
                                Button("Galeria de fotos") {
                                    showImagePicker = true
                                }
                            }
                            .photosPicker(isPresented: $showImagePicker, selection: $pickerItem, matching: .images, photoLibrary: .shared())
                            .onChange(of: pickerItem) {
                                Task {
                                    if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                                        colaborationViewModel.image = UIImage(data: data)
                                      //  selectedImage = UIImage(data: data)
                                        
                                        if let image = CIImage(data: data) {
                                            
                                            let properties = image.properties
                                            
                                            if let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
                                                let latitude = gps[kCGImagePropertyGPSLatitude as String] as! Double
                                                let longitude = gps[kCGImagePropertyGPSLongitude as String] as! Double
                                                
                                                colaborationViewModel.location = CLLocation(latitude: latitude, longitude: longitude)
                                            }
                                        }
                                        router.navigateTo(route: .newWork)
                                        return
                                    }
                                }
                            }
                            .fullScreenCover(isPresented: $showCamera) {
                                AccessCameraView(colaborationViewModel: colaborationViewModel, navigate: $navigateFromCamera)
                                    .background(.black)
                            }
                            .onChange(of: navigateFromCamera) {
                                if navigateFromCamera == true {
                                    router.navigateTo(route: .newWork)
                                    navigateFromCamera = false
                                }
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
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Colaborar")
        .navigationDestination(for: ColaborationNavigationDestinations.self, destination: { screen in
            switch screen {
            case .newWork:
                NewWorkView(colaborationViewModel: colaborationViewModel)
                    .environment(router)
            case .reviewNewWork:
                ReviewNewWorkView(colaborationViewModel: colaborationViewModel)
                    .environment(router)
            }
        })
        .onAppear {
            colaborationViewModel.location = locationManager.location
        }
    }
}
//
//#Preview {
//    ColaborationView()
//}
