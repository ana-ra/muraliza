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
    let work: LocalWork
    
    
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
                        // Navigate to tag
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

#Preview {
    TagsSubView(work: LocalWork(id: UUID(), title: "Teste", description: "Rorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.", image: UIImage(), location: CLLocation(latitude: -22, longitude: 47), tag: ["Colorido", "Bomb", "Lettering", "Teste1", "Teste2", "Teste3"], artist: nil))
}
