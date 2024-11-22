//
//  NextToYou.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 24/10/24.
//

import SwiftUI

struct NextToYouSubview: View {
    @State var works: [Work]
    
    @Binding var showCard: Bool
    @Binding var cardWorkId: String
    
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Text("Artes próximas a você")
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
                                .frame(width: getWidth()/3, height: getHeight()/6)
                        }
                    }.padding(.trailing, -8)
                }.padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    NextToYouSubview()
//}
