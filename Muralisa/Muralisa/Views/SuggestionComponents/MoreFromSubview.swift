//
//  ForYouSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI

struct MoreFromSubview: View {
    @Binding var works: [Work]
    
    @Binding var showCard: Bool
    @Binding var cardWorkId: String
    
    var body: some View {
        VStack(alignment:.leading){
            HStack {
                Text("Mais do artista")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Spacer()
            }
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(works, id: \.self) { work in
                        Button {
                            showCard = true
                            cardWorkId = work.id
                        } label: {
                            Image(uiImage: work.imageThumb)
                                .resizable()
                                .frame(width: 143, height: 128)
                        }
                        
                    }.padding(.trailing, -8)
                }.padding(.horizontal)
            }
            
        }
    }
}

//#Preview {
//    ForYouSubview(imageService: ImageService())
//}
