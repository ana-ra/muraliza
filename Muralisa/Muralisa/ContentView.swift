//
//  ContentView.swift
//  Muralisa
//
//  Created by Guilherme Ferreira Lenzolari on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var isLiked = false
    @State var isExpanded = false
//    let work: Work?
    var body: some View {
        VStack(alignment:.leading) {
            ZStack(alignment:.bottomTrailing){
                
                if isExpanded {
                    Image("imagePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(25)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                } else {
                    Image("imagePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 330)
                        .cornerRadius(25)
                        .onTapGesture {
                            isExpanded.toggle()  // Expande a imagem
                        }}
                
                
                Button {
                    isLiked.toggle()
                } label: {
                    ZStack{
                        
                        Image(systemName: isLiked ? "heart.circle.fill" : "heart.circle")
                            .resizable()
                            .foregroundStyle( isLiked ? Color.gray : Color.blue )
                            .frame(width: 50,height: 50,alignment: .trailing)
                        
                    }.padding()
                }
                
            }
            
            Text("Title")
                .padding(.top)
                .font(Font.title)
                .fontWeight(.bold)
            
            Text("Description")
            
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
