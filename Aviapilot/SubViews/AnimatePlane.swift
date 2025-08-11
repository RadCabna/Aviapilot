//
//  AnimatePlane.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 04.08.2025.
//

import SwiftUI

struct AnimatePlane: View {
    @State private var xScale:CGFloat = 1
    @State private var yScale:CGFloat = 1
    @State private var animateTimer: Timer? = nil
    @Binding var isRiding: Bool
    var image = "plane1_1"
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(height: screenHeight*0.07)
            .scaleEffect(x: xScale, y: yScale)
        
            .onAppear {
                startPlaneAnimation()
            }
           
            .onChange(of: isRiding) { _ in
                if isRiding {
                    startPlaneAnimation()
                } else {
                    stopAnimation()
                }
            }
    }
    
    func startPlaneAnimation() {
        animateTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(Animation.easeInOut(duration: 0.1)) {
                xScale = 1.1
                yScale = 0.95
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation(Animation.easeInOut(duration: 0.1)) {
//                    xScale = 0.95
//                    yScale = 1.05
//                }
//            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(Animation.easeInOut(duration: 0.1)) {
                    xScale = 1
                    yScale = 1
                }
            }
        }
    }
    
    func stopAnimation() {
        animateTimer?.invalidate()
        animateTimer = nil
        xScale = 1
        yScale = 1
    }
}

#Preview {
    AnimatePlane(isRiding: .constant(false))
}
