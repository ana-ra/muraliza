//
//  ImageSubview.swift
//  Muralisa
//
//  Created by Bruno Dias on 21/10/24.
//

import SwiftUI
import CoreLocation

struct ImageSubview: View {
    
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    var work: Work
    @State var isLiked = false
    @State private var isVisible = true
    
    @State private var scale: CGFloat = 1.0
    
    @Binding var isCompressed: Bool

    var body: some View {
        VStack(alignment:.leading) {
            ZStack(alignment:.bottomTrailing){
                
                
                Image(uiImage: work.image)
                    .resizable()
                    .aspectRatio(contentMode: isCompressed ? .fill : .fit)
                    .frame(height: isCompressed ? getHeight()/2.5 : nil)
                    .frame(maxWidth: isCompressed ? getWidth() - 32 : .infinity)
                    .cornerRadius(25)
                    .addPinchZoom()
                
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


// Add Pinch to Zoom Custom Modifier
extension View {
    func addPinchZoom() -> some View {
        return PinchZoomContext {
            self
        }
    }
}

// Helper Structs
struct PinchZoomContext<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    @State var offset: CGPoint = .zero
    @State var scale: CGFloat = 0
    
    @State var scalePosition: CGPoint = .zero
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    var body: some View {
        content
            .offset(x: offset.x, y: offset.y)
            .overlay(
                
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZoomGesture(size: size, scale: $scale, offset: $offset, scalePosition: $scalePosition)
                    
                }
            )
            .scaleEffect(1 + (scale < 0 ? 0 : scale), anchor: .init(x: scalePosition.x, y: scalePosition.y))
            .zIndex(scale != 0 ? 1000 : 0)
            .onChange(of: scale) {
                
                isZooming = (scale != 0 || offset != .zero)
                
                if scale == -1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        scale = 0
                    }
                }
            }
    }
}

struct ZoomGesture: UIViewRepresentable {
    
    var size: CGSize
    
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    
    @Binding var scalePosition: CGPoint
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let PinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        
        
        let PanGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        
        PanGesture.delegate = context.coordinator
        
        
        view.addGestureRecognizer(PinchGesture)
        view.addGestureRecognizer(PanGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        
        var parent: ZoomGesture
        
        init(parent: ZoomGesture) {
            self.parent = parent
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        @objc
        func handlePan(sender: UIPanGestureRecognizer) {
            
            sender.maximumNumberOfTouches = 2
            
            if sender.state == .began || sender.state == .changed && parent.scale > 0 {
                
                if let view = sender.view {
                    let translation = sender.translation(in: view)
                    
                    parent.offset = translation
                }
                
            } else {
                withAnimation {
                    parent.offset = .zero
                    parent.scalePosition = .zero
                }
            }
        }
        
        @objc
         func handlePinch(sender: UIPinchGestureRecognizer) {
            if sender.state == .began || sender.state == .changed {
                parent.scale = (sender.scale - 1)
                
                let scalePoint = CGPoint(x: sender.location(in: sender.view).x / (sender.view?.frame.size.width ?? 1), y: sender.location(in: sender.view).y / (sender.view?.frame.height ?? 1))
                
                parent.scalePosition = (parent.scalePosition == .zero ? scalePoint : parent.scalePosition)
                
            } else {
                withAnimation(.easeInOut(duration: 0.35)) {
                    parent.scale = -1
                    parent.scalePosition = .zero
                }
            }
        }
    }
}
