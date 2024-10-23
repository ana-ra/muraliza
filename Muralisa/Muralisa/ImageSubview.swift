//
//  ImageSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI

struct ImageSubview: View {
//    let workImage: UIImage
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
                
                
                
                
                
                
                
                
//                Button("􀊵") {isLiked.toggle()}
//                        .buttonStyle(.borderedProminent)
//                        .tint(.blue)
//                        .controlSize(.large)
//                        .disabled(isLiked)
                
                Button {
                    isLiked.toggle()
                } label: {
                    
                    ZStack{
                        Circle()
                            .frame(width: 50)
                            .foregroundStyle( isLiked ? Color.blue : Color.gray.opacity(0.20) )
                        Image(systemName: isLiked ? "heart.fill" : "heart.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 16,height: 16,alignment: .trailing)
                        
                    }.padding()
                }
                
            }
            
            Text("Title")
                .padding(.top)
                .font(Font.title)
                .fontWeight(.bold)
            
            Text("Description")
                .multilineTextAlignment(.leading)
                
            
            
        }
        .padding()
    }
}

#Preview {
    ImageSubview()
}
