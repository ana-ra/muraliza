//
//  AsyncImageView.swift
//  Muralisa
//
//  Created by Gustavo Sacramento on 26/10/24.
//

import SwiftUI
import CloudKit

// Attempt to create a view that waits for the fetch to show the image
// So we don't have to convert all images before showing, work still in progress
struct AsyncImageView: View {
    let record: CKRecord
    let workService: WorkService
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("loading...")
            }
        }
        .task {
            await loadImageFromRecord()
        }
    }
    
    private func loadImageFromRecord() async {
        do {
            let work = try await workService.convertRecordToWork(record)
            self.image = work.image
        } catch {
            print("Error loading image data: \(error)")
        }
    }
}

//#Preview {
//    AsyncImageView()
//}
