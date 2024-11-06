//
//  MuralisaApp.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

@main
struct MuralisaApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Sugestão", systemImage: "wand.and.rays.inverse") {
                    SuggestionView()
                }
                
                Tab("Colaborar", systemImage: "photo.badge.plus.fill") {
                    ColaborationView()
                }
                
                Tab("Curadoria", systemImage: "rectangle.and.text.magnifyingglass") {
                    CurationView()
                }
            }
            .onDisappear {
                deleteFilesInAssets()
            }
        }
    }
}

extension MuralisaApp {
    // Entry point to start the search from the caches directory
    func deleteFilesInAssets() {
        let fileManager = FileManager.default
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Could not find caches directory.")
            return
        }

        // Start searching for the Assets directory
        deleteFilesInAssetsDirectory(at: cachesDirectory)
    }
    
    func deleteFilesInAssetsDirectory(at url: URL) {
        let fileManager = FileManager.default

        do {
            // List all contents in the current directory
            let filePaths = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

            for filePath in filePaths {
                // Check if the item is a directory
                if (try? filePath.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
                    // If it is the Assets directory, delete all files in it
                    if filePath.lastPathComponent == "Assets" {
                        print("Found Assets directory: \(filePath.path)")
                        // Delete all files in the Assets directory
                        deleteAllFilesInDirectory(at: filePath)
                        return // Stop searching after deleting
                    } else {
                        // Continue searching in this directory
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
