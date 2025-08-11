//
//  WinView.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 05.08.2025.
//

import SwiftUI

struct WinView: View {
    @EnvironmentObject var coordinator: Coordinator
    @AppStorage("levelNumber") var levelNumber: Int = 1
    @AppStorage("coinCount") var coinCount = 0
    @State private var trophyData = UserDefaults.standard.array(forKey: "trophyData") as? [Int] ?? Array(repeating: 0, count: 5)
    @State private var questData = UserDefaults.standard.array(forKey: "questData") as? [Int] ?? Array(repeating: 0, count: 5)
    @Binding var time: Int
    @Binding var planeCount: Int
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
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
                            Text("GOOD!")
                                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.05))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, screenHeight*0.005)
                        }
                    )
                Spacer()
                ZStack {
                    Image(.levelCompleteFrame)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.5)
                    VStack {
                        Image(.timerFrame)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.1)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("planes took off:")
                                        .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, screenHeight*0.005)
                                    Text("\(planeCount)")
                                        .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.03))
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, screenHeight*0.005)
                                }
                            )
                        Image(.timerFrame)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.1)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("TIME SPEND:")
                                        .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, screenHeight*0.005)
                                    Text(String(format: "%02d:%02d", 0, 60-time))
                                        .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.03))
                                        .foregroundStyle(Color.white)
                                        .padding(.bottom, screenHeight*0.005)
                                }
                            )
                    }
                    .offset(y: screenHeight*0.06)
                    HStack {
                        Image(.repeatButton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.08)
                            .onTapGesture {
                                coinCount += planeCount*15
                                coordinator.navigate(to: .mainMenu)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    coordinator.navigate(to: .game)
                                }
                            }
                        Image(.nextButton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.08)
                            .onTapGesture {
                                coinCount += planeCount*15
                                levelNumber += 1
                                coordinator.navigate(to: .mainMenu)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    coordinator.navigate(to: .game)
                                }
                            }
                    }
                    .offset(y: screenHeight*0.24)
                }
                Spacer()
            }
        }
        
        .onAppear {
            trophyData[1] = 1
            questData[0] = 1
            coinCount += 500
            UserDefaults.standard.setValue(questData, forKey: "questData")
            UserDefaults.standard.setValue(trophyData, forKey: "trophyData")
        }
        
    }
}

#Preview {
    WinView(time: .constant(45), planeCount: .constant(5))
}
