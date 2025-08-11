//
//  Menu.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Menu: View {
    @EnvironmentObject var coordinator: Coordinator
    @AppStorage("coinCount") var coinCount = 0
    @AppStorage("sound1") var sound1 = true
    @State private var darkOpacity: CGFloat = 0
    @State private var showSettings = false
    @State private var showQuest = false
    @State private var showTrophies = false
    @State private var showSkins = false
    var body: some View {
        ZStack {
            Background(backgroundNumber: 2)
            Image(.loadingLogo)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.2)
                .offset(y: -screenHeight*0.3)
            Image(.coinFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.05)
                .overlay(
                    HStack {
                        Spacer()
                        Text("\(coinCount)")
                            .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.02))
                            .foregroundStyle(Color.white)
                            .padding(.trailing, screenHeight*0.02)
                            .padding(.bottom, screenHeight*0.003)
                    }
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom)
            VStack {
                HStack {
                   Buttons()
                        .onTapGesture {
                            showSettings.toggle()
                        }
                    Spacer()
                    Buttons(image: "questButton", text: "quest")
                        .onTapGesture {
                            showQuest.toggle()
                        }
                }
                .padding(.horizontal)
                HStack {
                   Buttons(image: "trophiesButton", text: "trophies")
                        .onTapGesture {
                            showTrophies.toggle()
                        }
                    Spacer()
                    Buttons(image: "skinsButton", text: "skins")
                        .onTapGesture {
                            showSkins.toggle()
                        }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            Text("TAP TO START")
                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.03))
                .foregroundStyle(Color.white)
                .offset(y: screenHeight*0.22)
                .onTapGesture {
                    coordinator.navigate(to: .game)
                }
            Color.black.opacity(darkOpacity).ignoresSafeArea()
            
            if showSkins {
                Skins(showSkins: $showSkins)
            }
            if showTrophies {
                Trophies(showTrophies: $showTrophies)
            }
            if showSettings {
                Settings(showSettings: $showSettings)
            }
            if showQuest {
                Quest(showQuest: $showQuest)
            }
        }
        
        .onChange(of: showSettings) { _ in
            if showSettings {
                showSubMenu()
            } else {
                hideSubMenu()
            }
        }
        .onChange(of: showQuest) { _ in
            if showQuest {
                showSubMenu()
            } else {
                hideSubMenu()
            }
        }
        .onChange(of: showTrophies) { _ in
            if showTrophies {
                showSubMenu()
            } else {
                hideSubMenu()
            }
        }
        .onChange(of: showSkins) { _ in
            if showSkins {
                showSubMenu()
            } else {
                hideSubMenu()
            }
        }
        
        .onAppear {
            if sound1 {
                SoundManager.instance.stopAllSounds()
                SoundManager.instance.playSound(sound: "soundMain")
            } else {
                SoundManager.instance.stopAllSounds()
            }
        }
        
    }
    
    func showSubMenu() {
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            darkOpacity = 0.6
        }
    }
    
    func hideSubMenu() {
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            darkOpacity = 0
        }
    }
    
}

#Preview {
    Menu()
}
