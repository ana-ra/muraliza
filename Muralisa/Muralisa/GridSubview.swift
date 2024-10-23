//
//  GridSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 22/10/24.
//

import SwiftUI

struct GridSubview: View {
    var mockedList: [String] = ["imagePlaceholder", "imag", "imag","imagePlaceholder", "ima", "imagePlaceholder"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(mockedList, id: \.self) { item in
                    Button {
                        print("Button tapped")
                    } label: {
                        Image("\(item)")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFill()
                    }
                }
            }
            
        }
    }
}

#Preview {
    GridSubview()
}
