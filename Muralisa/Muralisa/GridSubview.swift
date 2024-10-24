//
//  GridSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 22/10/24.
//

import SwiftUI

struct GridSubview: View {
    private var data = Array(1...12)
    

    @State var fixedColumn = [
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
                LazyVGrid(columns: fixedColumn, spacing: 0) {
                    ForEach(data, id: \.self) { item in
                        Image("imagePlaceholder")
                            .resizable()
                            .scaledToFit()
//                            .frame(height: getWidth()/3*1.34)
                    }
                }
            }
            
        }
        .onAppear {
              fixedColumn = [
                GridItem(.flexible(),spacing: 0),
                GridItem(.flexible(),spacing: 0),
                GridItem(.flexible(),spacing: 0),
            ]
        }
    }
}

#Preview {
    GridSubview()
}
