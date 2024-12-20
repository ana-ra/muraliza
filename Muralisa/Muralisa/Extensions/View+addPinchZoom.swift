//
//  View+addPinchZoom.swift
//  Muralisa
//
//  Created by Rafael Antonio Chinelatto on 31/10/24.
//

import SwiftUI

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
