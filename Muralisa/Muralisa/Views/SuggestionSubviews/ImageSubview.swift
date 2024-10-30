//
//  ImageSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI
import CoreLocation

struct ImageSubview: View {
    
    var work: Work
    @State var isLiked = false
    @State private var isVisible = true
    
    // Animation
    @Binding var isCompressed: Bool
//    @Binding var showMore: Bool

    var body: some View {
        VStack(alignment:.leading) {
            ZStack(alignment:.bottomTrailing){
                
                
                Image(uiImage: work.image)
                    .resizable()
                    .aspectRatio(contentMode: isCompressed ? .fill : .fit)
                    .frame(height: isCompressed ? getHeight()/2.5 : nil)
                    .frame(maxWidth: isCompressed ? getWidth() - 32 : .infinity)
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
                    toggleOpacityWithDelay()
                    isVisible = false
                } label: {
                    Label(isCompressed ? "Mostrar Mais" : "Mostrar Menos", systemImage: isCompressed ? "arrow.down.left.and.arrow.up.right" : "arrow.up.right.and.arrow.down.left")
                        .opacity(isVisible ? 1.0 : 0.0) // Apply opacity based on state
                        .animation(.easeInOut(duration: 0), value: isVisible)
                }
                Spacer()
            }
            
            if let title = work.title {
                Text(title)
                    .padding(.top)
                    .font(Font.title)
                    .fontWeight(.bold)
                
                if let description = work.workDescription {
                    Text(description)
                        .multilineTextAlignment(.leading)
                }
            }
            else {
                if let description = work.workDescription {
                    Text("Sem Título")
                        .padding(.top)
                        .font(Font.title)
                        .fontWeight(.bold)
                    
                    Text(description)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding()
    }
    
    // Toggle opacity on and off with a delay
    func toggleOpacityWithDelay() {
        // Repeat with a timer or dispatch after a delay
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            withAnimation {
                isVisible = true
            }
        }
    }
}
