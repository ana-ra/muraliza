//
//  GridSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 22/10/24.
//

import SwiftUI

struct GridSubview: View {
    private var data = Array(1...12)
    
    private let fixedColumn = [
        GridItem(.fixed(125)),
        GridItem(.fixed(125)),
        GridItem(.fixed(125))
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
                LazyVGrid(columns: fixedColumn, spacing: 8) {
                    ForEach(data, id: \.self) { item in
                        Text(String(item))
                            .frame(width: 125, height: 125, alignment: .center)
                            .background(Color.green)
//                            .cornerRadius(8)
                            .font(.title)
                    }
                }
                .padding(8)
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    GridSubview()
}
