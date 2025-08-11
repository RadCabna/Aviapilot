//
//  Loading.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Loading: View {
    @AppStorage("levelInfo") var level = false
    @EnvironmentObject var coordinator: Coordinator
    @State private var loadingProgress: CGFloat = 1
    var body: some View {
        ZStack {
            Background(backgroundNumber: 1)
            Image(.loadingLogo)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.2)
            ZStack {
                Image(.loadingBarBack)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight*0.06)
                Image(.loadingBarFront)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight*0.048)
                    .offset(x: -screenHeight*0.4*loadingProgress)
                    .mask {
                        Image(.loadingBarFront)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.048)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom)
        }
        
        .onChange(of: level) { _ in
            if level {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    coordinator.navigate(to: .mainMenu)
                }
            }
        }
        
        .onAppear {
            loadingProgressAnimation()
        }
        
    }
    
    func loadingProgressAnimation() {
        withAnimation(Animation.easeInOut(duration: 4)) {
            loadingProgress = 0
        }
    }
    
}

#Preview {
    Loading()
}
