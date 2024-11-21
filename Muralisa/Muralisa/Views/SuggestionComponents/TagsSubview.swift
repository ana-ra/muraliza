//
//  tagsSubview.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 21/10/24.
//

import SwiftUI
import CoreLocation
import WrappingHStack

struct TagsSubView: View {
    
    let work: Work
    @Binding var navigateToTagView: Bool
    @Binding var selectedTag: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tags")
                    .font(.subheadline)

                Spacer()
            }
            
            WrappingHStack(alignment: .leading) {
                ForEach(work.tag, id: \.self) { tag in
                    
                    Button {
                        navigateToTagView = true
                        selectedTag = tag
                    } label: {
                        Text(tag)
                            .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.gray)
                            .opacity(0.2)
                    }
                    
                }
            }
        }
        .padding()
    }
}
