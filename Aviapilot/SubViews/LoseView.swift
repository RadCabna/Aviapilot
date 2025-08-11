//
//  LoseView.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 11.08.2025.
//

import SwiftUI

struct LoseView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var planeOffset: CGFloat = 0
    var body: some View {
        ZStack {
            Color.red.opacity(0.5).ignoresSafeArea()
            VStack {
                Image(.topFrame)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        ZStack {
                            Image(.homeButton)
                                .resizable()
                                .scaledToFit()
                                .frame(height: screenHeight*0.04)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, screenHeight*0.03)
                                .onTapGesture {
                                    coordinator.navigate(to: .mainMenu)
                                }
                            Text("LOSE!")
                                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.05))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, screenHeight*0.005)
                        }
                    )
                Spacer()
                Image(.bigPlane)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight*0.4)
                    .offset(y: planeOffset)
                Spacer()
                Image(.repeatButton)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight*0.1)
                    .padding(.bottom)
                    .onTapGesture {
                        coordinator.navigate(to: .mainMenu)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            coordinator.navigate(to: .game)
                        }
                    }
                    .offset(y: planeOffset)
            }
        }
        
        .onAppear {
            planeAnimation()
        }
        
    }
    
    func planeAnimation() {
        planeOffset = screenHeight
        withAnimation(Animation.easeInOut(duration: 2)) {
            planeOffset = 0
        }
    }
    
}

#Preview {
    LoseView()
}
