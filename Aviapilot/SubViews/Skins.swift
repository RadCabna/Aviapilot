//
//  Skins.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Skins: View {
    @AppStorage("planeSet") var planeSet = 0
    @AppStorage("coinCount") var coinCount = 0
    @State private var shopItemsArray = Arrays.shopItemsArray
    @State private var shopItemsData = UserDefaults.standard.array(forKey: "shopItemsData") as? [Int] ?? [2,0,0,0,0]
    @Binding var showSkins: Bool
    var body: some View {
        ZStack {
            Image(.skinsFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.7)
                .overlay {
                    ZStack {
                        Text("Skins")
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
                                showSkins.toggle()
                            }
                        VStack {
                            ForEach(0..<shopItemsArray.count, id:\.self) { item in
                                Image(.shopItemRectangle)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: screenHeight*0.095)
                                    .overlay(
                                        HStack {
                                            Image(shopItemsArray[item].image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: screenHeight*0.08)
                                            Text(shopItemsArray[item].name)
                                                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                                                .foregroundStyle(Color.redText)
                                            Spacer()
                                            if shopItemsData[item] == 2 {
                                                Image(.grayShopButton)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: screenHeight*0.06)
                                                    .overlay(
                                                        Text("Use")
                                                            .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                                                            .foregroundStyle(.white)
                                                            .shadow(color: .black, radius: 2)
                                                    )
                                            }
                                            if shopItemsData[item] == 1 {
                                                Image(.greenShopButton)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: screenHeight*0.06)
                                                    .overlay(
                                                        Text("Owned")
                                                            .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.02))
                                                            .foregroundStyle(.white)
                                                            .shadow(color: .black, radius: 2)
                                                    )
                                                    .onTapGesture {
                                                        selectItem(item: item)
                                                    }
                                            }
                                            
                                            if shopItemsData[item] == 0 {
                                                Image(.greenShopButton)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: screenHeight*0.06)
                                                    .overlay(
                                                        HStack(spacing: screenHeight*0.005) {
                                                            Image(.coin)
                                                            Text("\(shopItemsArray[item].price)")
                                                                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.02))
                                                                .foregroundStyle(.white)
                                                                .shadow(color: .black, radius: 2)
                                                                .padding(.bottom, screenHeight*0.003)
                                                        }
                                                    )
                                                    .onTapGesture {
                                                        buyItem(item: item)
                                                    }
                                            }
                                            
                                        }
                                            .frame(maxWidth: screenHeight*0.295)
                                    )
                            }
                        }
                        .offset(y: screenHeight*0.06)
                    }
                }
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
        }
    }
    
    func buyItem(item: Int) {
        if coinCount >= shopItemsArray[item].price {
            coinCount -= shopItemsArray[item].price
            shopItemsData[item] = 1
            UserDefaults.standard.setValue(shopItemsData, forKey: "shopItemsData")
            
        }
    }
    
    func selectItem(item: Int) {
        if shopItemsData[item] == 1 {
            for i in 0..<shopItemsData.count {
                if shopItemsData[i] == 2 {
                    shopItemsData[i] = 1
                }
            }
            shopItemsData[item] = 2
            planeSet = item
            UserDefaults.standard.setValue(shopItemsData, forKey: "shopItemsData")
        }
    }
    
}

#Preview {
    Skins(showSkins: .constant(true))
}
