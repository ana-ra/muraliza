//
//  ImageSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI
import CoreLocation
import SwiftData

struct ImageSubview: View {
    
    @Query var user: [User]
    @Environment(\.modelContext) var context
    
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    var work: Work
    @State var isLiked = false
    @State private var isVisible = true
    
    @State private var scale: CGFloat = 1.0
    
    @Binding var isCompressed: Bool

    var body: some View {
        VStack(alignment:.leading) {
            ZStack(alignment:.bottomTrailing){
                
                
                if let image = work.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: isCompressed ? .fill : .fit)
                        .frame(height: isCompressed ? getHeight()/2.5 : nil)
                        .frame(maxWidth: isCompressed ? getWidth() - 32 : .infinity)
                        .cornerRadius(25)
                        .addPinchZoom()
                } else {
                    Image(uiImage: work.imageThumb)
                        .resizable()
                        .aspectRatio(contentMode: isCompressed ? .fill : .fit)
                        .frame(height: isCompressed ? getHeight()/2.5 : nil)
                        .frame(maxWidth: isCompressed ? getWidth() - 32 : .infinity)
                        .cornerRadius(25)
                        .addPinchZoom()
                }

                
                if let user = user.first {
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
                    }.onAppear {
                        if let favoritesId = user.favoritesId {
                            if favoritesId.contains(work.id) {
                                isLiked = true
                            } else {
                                isLiked = false
                            }
                        } else {
                            isLiked = false
                        }

                    }.onChange(of: isLiked) {
                        
                        if var favoritesId = user.favoritesId {
                           
                            if isLiked == false {
                                favoritesId.removeAll { $0 == work.id }
                                self.user.first?.favoritesId = favoritesId
                            } else {
                                favoritesId.append(work.id)
                                self.user.first?.favoritesId = favoritesId
                            }
                            
                        } else {
                            if isLiked == true {
                                self.user.first?.favoritesId = [self.work.id]
                            }
                        }
                    }
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
                        .opacity(isZooming ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 0), value: isVisible)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top)
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

