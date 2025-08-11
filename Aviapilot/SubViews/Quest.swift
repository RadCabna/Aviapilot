//
//  Quest.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Quest: View {
    @State private var questData = UserDefaults.standard.array(forKey: "questData") as? [Int] ?? Array(repeating: 0, count: 5)
    @State private var questArray = Arrays.questArray
    @Binding var showQuest: Bool
    var body: some View {
        ZStack {
            Image(.questsFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.8)
                .overlay(
                    VStack {
                        ForEach(0..<questArray.count, id: \.self) { item in
                            Image(questData[item] == 1 ? .questDoneFrame : .questNotDoneFrame)
                                .resizable()
                                .scaledToFit()
                                .frame(height: screenHeight*0.14)
                                .overlay(
                                    ZStack {
                                        Image(.coinFrame)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: screenHeight*0.05)
                                            .overlay(
                                                HStack {
                                                    Spacer()
                                                    Text("500")
                                                        .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.02))
                                                        .foregroundStyle(Color.white)
                                                        .padding(.trailing, screenHeight*0.02)
                                                        .padding(.bottom, screenHeight*0.003)
                                                }
                                            )
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                            .padding(.trailing, screenHeight*0.007)
                                            .padding(.bottom, screenHeight*0.007)
                                        
                                        VStack(alignment: .leading) {
                                            Text(questArray[item].headText)
                                                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                                                .foregroundStyle(questData[item] == 1 ? Color.redText : .white)
                                            Text(questArray[item].text)
                                                .font(Font.custom("SF Pro Display", size: screenHeight*0.02))
                                                .foregroundStyle(questData[item] == 1 ? Color.redText : .white)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .padding(.top)
                                    }
                                )
                        }
                    }
                )
            Image(.crossButton)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.07)
                .offset(x: screenHeight*0.19, y: -screenHeight*0.39)
                .onTapGesture {
                    showQuest.toggle()
                }
        }
    }
}

#Preview {
    Quest(showQuest: .constant(true))
}


