//
//  Settings.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Settings: View {
    @AppStorage("sound1") var sound1 = true
    @AppStorage("sound2") var sound2 = true
    @AppStorage("sound3") var sound3 = true
    @AppStorage("vibration") var vibration = true
    @Binding var showSettings: Bool
    var body: some View {
        ZStack {
            Image(.settingsTopFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth)
                .overlay(
                    ZStack {
                        Text("Settings")
                            .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.06))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2)
                            .padding(.bottom)
                        Image(.arrowBack)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.06)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding(.bottom)
                            .onTapGesture {
                                showSettings.toggle()
                            }
                    }
                )
                .offset(y: -screenHeight*0.28)
            Image(.settingsFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.1)
                .overlay(
                    HStack(spacing: screenHeight*0.02) {
                        Image(sound1 ? .soundButton1 : .soundButton1Off)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.07)
                            .onTapGesture {
                                sound1.toggle()
                            }
                        Image(sound2 ? .soundButton2 : .soundButton2Off)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.07)
                            .onTapGesture {
                                sound2.toggle()
                            }
                        Image(sound3 ? .soundButton3 : .soundButton3Off)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.07)
                            .onTapGesture {
                                sound3.toggle()
                            }
                        Image(vibration ? .soundButton4 : .soundButton4Off)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.07)
                            .onTapGesture {
                                vibration.toggle()
                            }
                    }
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, screenHeight*0.15)
        }
        
        .onChange(of: sound1) { _ in
            if sound1 {
                SoundManager.instance.stopAllSounds()
                SoundManager.instance.playSound(sound: "soundMain")
            } else {
                SoundManager.instance.stopAllSounds()
            }
        }
        
    }
}

#Preview {
    Settings(showSettings: .constant(true))
}
