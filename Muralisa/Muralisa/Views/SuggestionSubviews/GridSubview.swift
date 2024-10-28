//
//  GridSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 22/10/24.
//

import SwiftUI
import CloudKit

struct GridSubview: View {
    @State var workRecords: [CKRecord]
    
    var fixedColumn = [
        GridItem(.flexible(),spacing: 0),
        GridItem(.flexible(),spacing: 0),
        GridItem(.flexible(),spacing: 0),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Similares a Gustavo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
            }
                        
            ScrollView {
                LazyVGrid(columns: fixedColumn, spacing: 0) {
                    ForEach(workRecords, id: \.self) { record in
                        CachedWork(workRecordName: record.recordID.recordName, animation: .easeInOut, transition: .scale.combined(with: .opacity)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
//                                    .background(.blue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure(let error):
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.white)
                                    .scaledToFit()
                                    .background(.blue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            default:
                                EmptyView()
                            }
                        }
//                        Image(uiImage: work.image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: getWidth()/3*1.34])
                    }
                }
            }
        }
    }
}

//#Preview {
//    GridSubview()
//}
