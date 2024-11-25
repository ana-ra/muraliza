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
    case newWorkLoadingView
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
        
        Group {
            
            if works.isEmpty {
                VStack(alignment: .center, spacing: 24) {
                    Spacer()
                    Image(.cameraLock)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundStyle(Color.brandingSecondary)
                        .opacity(0.4)
                    
                    Text("Você ainda não possui obras adicionadas")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                        .padding(.bottom, -16)
                    
                    Text("Clique em **\(Image(systemName: "plus"))** para adicionar novas obras à nossa coleção de artes urbanas!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal, 4)
            } else {
                List {
                    
                    if works.count < 4 {
                        Section {
                            Spacer()
                                .listRowBackground(Color.clear)
                        }
                        .listSectionSpacing(works.count == 3 ? 0 : 12)
                            
                    }
                    
                    Section {
                        Image(.lookLogGirl)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(Color.brandingSecondary)
                            .listRowBackground(Color.clear)
                    }
                    
                    RecentlyAddedSection(works: works)
                        .listSectionSeparator(.hidden)
                    
                }
                .listRowSeparator(.hidden)
            }
        }
        .toolbar {
            
            //TODO: se não tiver logado, chamar a tela para fazer login
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingOptions = true
                } label: {
                    Image(systemName: "plus")
                }
            }
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
                    pickerItem = nil
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
        .navigationTitle("Colaborar")
        .navigationDestination(for: ColaborationNavigationDestinations.self, destination: { screen in
            switch screen {
            case .newWork:
                NewWorkView(colaborationViewModel: colaborationViewModel)
                    .environment(router)
            case .reviewNewWork:
                ReviewNewWorkView(colaborationViewModel: colaborationViewModel)
                    .environment(router)
            case .newWorkLoadingView:
                NewWorkLoadingView()
                    .environment(router)
            }
        })
        .onAppear {
            colaborationViewModel.location = locationManager.location
        }
    }
}

#Preview {
    NavigationStack {
        ColaborationView()
            .environment(ColaborationRouter())
    }
}
