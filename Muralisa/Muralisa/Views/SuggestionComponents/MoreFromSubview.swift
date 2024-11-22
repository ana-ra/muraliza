//
//  ForYouSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI

struct MoreFromSubview: View {
    @Binding var works: [Work]
    
    var body: some View {
        VStack(alignment:.leading){
            HStack {
                Text("Mais de")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Spacer()
            }
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(works, id: \.self) { work in
                        Button {
                            print("id: \(work.id)")
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
