//
//  ForYouSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI

//@State var pageAtualization: Bool = false
var mockedList: [String] = ["imagePlaceholder", "imagePlaceholder", "imagePlaceholder","imagePlaceholder", "imagePlaceholder", "imagePlaceholder"]

struct ForYouSubview: View {
    var body: some View {
        VStack(alignment:.leading){
            Text("Para Você")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, -190)
            
            
        }
        ScrollView(.horizontal){
            HStack{
                ForEach(mockedList, id: \.self) { item in
                    
                    Button {
                        print("id: \(item)")
                    } label: {
                        Image(item)
                            .resizable()
                            .frame(width: 143, height: 128)
                    }
                    
                }.padding(.trailing, -8)
            }
        }
        
        
        
        
    }
}

#Preview {
    ForYouSubview()
}
