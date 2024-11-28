//
//  MuralisaApp.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI
import SwiftData

@main
struct MuralisaApp: App {
    @State var networkMonitor = NetworkMonitor()
    @State var locationManager = LocationManager()

    @State var colaborationRouter = ColaborationRouter()
    
    //swiftData container
    let container: ModelContainer = {
        let schema = Schema([User.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .private("iCloud.muralisa2"))
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }()
    
    init(){
      // override alerts tintColor bug
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.accent)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Sugestão", systemImage: "wand.and.rays.inverse") {
                    NavigationStack {
                        if networkMonitor.isConnected {
                            if locationManager.authorizationStatus == .authorizedWhenInUse {
                                SuggestionView()
                            } else {
                                DisabledLocationView(locationManager: locationManager)
                                    .navigationTitle("Sugestão")
                            }
                        } else {
                            NoConnectionView()
                                .navigationTitle("Sugestão")
                        }
                    }
                }
                
                Tab("Colaborar", systemImage: "photo.badge.plus.fill") {
                    NavigationStack(path: $colaborationRouter.navigationPath) {
                        if networkMonitor.isConnected {
                            if locationManager.authorizationStatus == .authorizedWhenInUse {
                                ColaborationView()
                                    .environment(colaborationRouter)
                            } else {
                                DisabledLocationView(locationManager: locationManager)
                                    .navigationTitle("Colaborar")
                            }
                        } else {
                            NoConnectionView()
                                .navigationTitle("Colaborar")
                        }
                    }
                }
                
                Tab("Curadoria", systemImage: "rectangle.and.text.magnifyingglass") {
                    CurationView()
                }
                Tab("Mapa", systemImage: "map"){
                    NavigationStack{
                        if networkMonitor.isConnected{
                            if locationManager.authorizationStatus == .authorizedWhenInUse{
                                MapView()
                                    .environmentObject(locationManager) // Passando o LocationManager
                                    .navigationTitle("Mapa")
                            } else {
                                DisabledLocationView(locationManager: locationManager)
                                    .navigationTitle("Mapa")
                            }
                        } else{
                            NoConnectionView()
                                .navigationTitle("Mapa")
                        }
                    }
                }
            }
            .onDisappear {
                deleteFilesInAssets()
            }
        }.modelContainer(container)
    }
}

extension MuralisaApp {
    func deleteFilesInAssets() {
        let fileManager = FileManager.default
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Could not find caches directory.")
            return
        }

        deleteFilesInAssetsDirectory(at: cachesDirectory)
    }
    
    func deleteFilesInAssetsDirectory(at url: URL) {
        let fileManager = FileManager.default

        do {
            let filePaths = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

            for filePath in filePaths {
                if (try? filePath.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
                    if filePath.lastPathComponent == "Assets" {
                        print("Found Assets directory: \(filePath.path)")
                        deleteAllFilesInDirectory(at: filePath)
                        return
                    } else {
                        deleteFilesInAssetsDirectory(at: filePath)
                    }
                }
            }
        } catch {
            print("Error accessing directory \(url.lastPathComponent): \(error)")
        }
    }

    func deleteAllFilesInDirectory(at url: URL) {
        let fileManager = FileManager.default

        do {
            // List all contents in the Assets directory
            let filePaths = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

            for filePath in filePaths {
                // Check if it's a file or a directory
                if (try? filePath.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == false {
                    // If it's a file, delete it
                    try fileManager.removeItem(at: filePath)
                    print("Deleted file: \(filePath.lastPathComponent)")
                }
            }

            print("All files in \(url.lastPathComponent) have been deleted.")

        } catch {
            print("Error deleting files in directory \(url.lastPathComponent): \(error)")
        }
    }
}


extension View {
    func getHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
