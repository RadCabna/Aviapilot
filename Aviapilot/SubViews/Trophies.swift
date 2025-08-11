//
//  Trophies.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Trophies: View {
    @State private var trophyArray = Arrays.trophyArray
    @State private var trophyData = UserDefaults.standard.array(forKey: "trophyData") as? [Int] ?? Array(repeating: 0, count: 5)
    @Binding var showTrophies: Bool
    
    var body: some View {
        ZStack {
            Image(.skinsFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.7)
                .overlay {
                    ZStack {
                        Text("Trophies")
                            .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.06))
                            .foregroundStyle(Color.headText)
                            .offset(y: -screenHeight*0.28)
                            .shadow(color: .black, radius: 2)
                        Image(.crossButton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.07)
                            .offset(x: screenHeight*0.18, y: -screenHeight*0.33)
                            .onTapGesture {
                                showTrophies.toggle()
                            }
                    }
                    VStack {
                        ForEach(0..<trophyArray.count, id:\.self) { item in
                            Image(.shopItemRectangle)
                                .resizable()
                                .scaledToFit()
                                .frame(height: screenHeight*0.095)
                                .overlay(
                                    HStack {
                                        Image(trophyArray[item].image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: screenHeight*0.07)
                                            .blur(radius: trophyData[item] == 1 ? 0 : 3)
                                        
                                        VStack(alignment: .leading) {
                                            Text(trophyArray[item].headText)
                                                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                                                .foregroundStyle(Color.redText)
                                            Text(trophyArray[item].text)
                                                .font(Font.custom("SF Pro Display", size: screenHeight*0.02))
                                                .foregroundStyle(Color.redText)

                                        }
                                        Spacer()
                                    }
                                )
                        }
                    }
                    .offset(y: screenHeight*0.06)
                }
        }
    }
}

#Preview {
    Trophies(showTrophies: .constant(true))
}


//Text(text)
//    .font(Font.custom("SF Pro Display", size: screenHeight*0.02))
//    .foregroundStyle(Color.black)
