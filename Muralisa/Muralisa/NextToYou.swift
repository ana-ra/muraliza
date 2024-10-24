//
//  NextToYou.swift
//  Muralisa
//
//  Created by Silvana Rodrigues Alves on 24/10/24.
//

import SwiftUI

//@State var pageAtualization: Bool = false
var mockedList2: [String] = ["imagePlaceholder", "imagePlaceholder", "imagePlaceholder","imagePlaceholder", "imagePlaceholder", "imagePlaceholder"]

struct NextToYou: View {
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Text("Artes próximas a você")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)

                Spacer()
            
            }

            
            
        }
        ScrollView(.horizontal){
            HStack{
                ForEach(mockedList2, id: \.self) { item in
                    
                    Button {
                        print("id: \(item)")
                    } label: {
                        Image(item)
                            .resizable()
                            .frame(width: getWidth()/3, height: getHeight()/6)
                    }
                    
                }.padding(.trailing, -8)
            }.padding(.horizontal)
        }
    }
}

#Preview {
    NextToYou()
}
