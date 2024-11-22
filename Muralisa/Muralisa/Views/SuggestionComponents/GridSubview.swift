//
//  GridSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 22/10/24.
//

import SwiftUI
import CloudKit

struct GridSubview: View {
    @Binding var workRecords: [Work]
    var title: String?
    
    @Binding var showCard: Bool
    @Binding var cardWorkId: String
    
    var fixedColumn = [
        GridItem(.flexible(),spacing: 0),
        GridItem(.flexible(),spacing: 0),
        GridItem(.flexible(),spacing: 0),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                }
            }
            
            ScrollView {
                LazyVGrid(columns: fixedColumn, spacing: 0) {
                    ForEach(workRecords, id: \.self) { work in
                        Button {
                            showCard = true
                            cardWorkId = work.id
                        } label: {
                            Image(uiImage: work.imageThumb)
                                .resizable()
                                .frame(width: getWidth()/3, height: getHeight()/6)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    GridSubview()
//}
