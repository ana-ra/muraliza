//
//  ImageSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI
import CoreLocation

struct ImageSubview: View {
    
    var work: LocalWork
//    let workImage: UIImage
    @State var isLiked = false
    @State var isCompressed = true
    @State var showMore = true
//    let work: Work?
    var body: some View {
        VStack(alignment:.leading) {
            ZStack(alignment:.bottomTrailing){
                
                Image(uiImage: work.image)
                    .resizable()
                    .aspectRatio(contentMode: isCompressed ? .fill : .fit)
                    .frame(height: isCompressed ? 330 : nil)
                    .frame(maxWidth: isCompressed ? nil : .infinity)
                    .cornerRadius(25)
                
                Button {
                    isLiked.toggle()
                } label: {
                    ZStack{
                        Circle()
                            .frame(width: 50)
                            .foregroundStyle( isLiked ? Color.accentColor : Color.gray.opacity(0.20) )
                        Image(systemName: isLiked ? "heart.fill" : "heart.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 16,height: 16,alignment: .trailing)
                        
                    }.padding()
                }
                
            }
            HStack {
                Spacer()
                Button {
                    isCompressed.toggle()
                    showMore.toggle()
                } label: {
                    Label(showMore ? "Mostrar Mais" : "Mostrar Menos", systemImage: showMore ? "arrow.down.left.and.arrow.up.right" : "arrow.up.right.and.arrow.down.left")
                        .animation(.interactiveSpring(duration: 0), value: showMore)
                }
                Spacer()
            }
            
            if let title = work.title {
                Text(title)
                    .padding(.top)
                    .font(Font.title)
                    .fontWeight(.bold)
                
                if let description = work.description {
                    Text(description)
                        .multilineTextAlignment(.leading)
                }
            }
            else {
                if let description = work.description {
                    Text("Sem Título")
                        .padding(.top)
                        .font(Font.title)
                        .fontWeight(.bold)
                    
                    Text(description)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .animation(.easeInOut, value: isCompressed)
        .padding()
    }
}

#Preview {
    ImageSubview(work: LocalWork(id: UUID(), title: "Título", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.", image: UIImage(named: "imagePlaceholder") ?? UIImage(), location: CLLocation(latitude: 13, longitude: 15), tag: ["teste"], artist: nil))
}
