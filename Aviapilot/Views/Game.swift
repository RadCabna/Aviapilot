//
//  Game.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Game: View {
    @State private var gameFrames = Arrays.gameFrames
    @State private var framePositions = Arrays.framePositions
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    @State private var xPosition: CGFloat = 0
    @State private var yPosition: CGFloat = 0
    @State private var figuresArray = Arrays.figuresArray
    @State private var figuresArrayForGame: [Figure] = []
    @State private var figuresCoordinates = Arrays.figuresCoordinates
    @State private var selectedFigure: Int = 0
    @State private var figureOpacity: CGFloat = 1
    @State private var presentedFiguresArray: [Figure] = [Figure(name: "", color: 1, type: 1)]
    @State private var isTouching: Bool = false
    var body: some View {
        ZStack {
            Color(.asphalt).ignoresSafeArea()
            Background(backgroundNumber: 3)
            Image(.bottomFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.17)
                .overlay(
                    ZStack {
                        
                    }
                    //                        HStack {
                    //
                    //                            Image(figuresArray[0].name)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(height: screenHeight*0.04)
                    //                            Image(figuresArray[6].name)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(height: screenHeight*0.04)
                    //                            Image(figuresArray[12].name)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(height: screenHeight*0.08)
                    //                                .offset(x: xOffset + xPosition, y: yOffset + yPosition)
                    //                                .gesture(
                    //                                        DragGesture()
                    //                                            .onChanged { value in
                    //                                                xPosition = value.translation.width
                    //                                                yPosition = value.translation.height
                    //                                            }
                    //                                            .onEnded { value in
                    //                                                xOffset += xPosition
                    //                                                yOffset += yPosition
                    //                                                xPosition = 0
                    //                                                yPosition = 0
                    //                                                print("Прямоугольник перемещен на смещение: x=\(xOffset), y=\(yOffset)")
                    //                                                print(screenHeight*0.04)
                    //                                            }
                    //                                    )
                    //                            Image(figuresArray[18].name)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(height: screenHeight*0.08)
                    //                            Image(figuresArray[24].name)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(height: screenHeight*0.08)
                    //                            Image(figuresArray[30].name)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(height: screenHeight*0.12)
                    //
                    //                        }
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            
            ForEach(0..<presentedFiguresArray.count, id: \.self) { index in
                ZStack {
                    ForEach(0..<figurePartsCoordinates(type: presentedFiguresArray[index].type ).count, id: \.self) { item in
                        Image(figureImage(type: presentedFiguresArray[index].type))
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.04)
                            .offset(x: figurePartsCoordinates(type: presentedFiguresArray[index].type)[item].x*screenHeight/932,
                                    y: figurePartsCoordinates(type: presentedFiguresArray[index].type)[item].y*screenHeight/932)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if !isTouching {
                                            selectedFigure = index
                                            isTouching = true
                                            
                                        }
                                        xPosition = value.translation.width + presentedFiguresArray[index].xPosition*screenHeight/932
                                        yPosition = value.translation.height + presentedFiguresArray[index].yPosition*screenHeight/932
                                    }
                                    .onEnded { value in
                                        xOffset += xPosition
                                        yOffset += yPosition
                                        xPosition = 0
                                        yPosition = 0
                                        print("Прямоугольник перемещен на смещение: x=\(xOffset), y=\(yOffset)")
                                        print(screenHeight*0.04)
                                        isTouching = false
                                    }
                            )
                        
                    }
                }
                .offset(x: presentedFiguresArray[index].xPosition*screenHeight/932, y: presentedFiguresArray[index].yPosition*screenHeight/932)
            }
            ZStack {
                ForEach(0..<figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type ).count, id: \.self) { item in
                    Image(figureImage(type: presentedFiguresArray[selectedFigure].type))
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.04)
                                            .offset(
                                                x: xOffset + xPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].x*screenHeight/932,
                                                y: yOffset + yPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].y*screenHeight/932
                                            )
                }
            }
            
            ZStack {
                ForEach(0..<gameFrames.count, id: \.self) { row in
                    ForEach(0..<gameFrames[row].count, id: \.self) { col in
                        Image(gameFrames[row][col].name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.04)
                            .offset(x: gameFrames[row][col].xPosition*screenHeight/932, y: gameFrames[row][col].yPosition*screenHeight/932)
                        
                    }
                }
            }
            .offset(y: screenHeight > 1000 ? screenHeight*0.014 : 0)
            Image(.zoneLine)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.28)
                .offset(x:screenHeight/932*175, y: screenHeight/932*170)
                .offset(y: screenHeight > 1000 ? screenHeight*0.014 : 0)
            Image(.zoneLine)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.28)
                .offset(x:-screenHeight/932*175, y: screenHeight/932*170)
                .offset(y: screenHeight > 1000 ? screenHeight*0.014 : 0)
            //            Rectangle()
            //                .frame(width: screenHeight*0.04, height: screenHeight*0.04)
            //                .opacity(0.4)
            //                .offset(x: xOffset + xPosition, y: yOffset + yPosition)
            //                .gesture(
            //                        DragGesture()
            //                            .onChanged { value in
            //                                xPosition = value.translation.width
            //                                yPosition = value.translation.height
            //                            }
            //                            .onEnded { value in
            //                                xOffset += xPosition
            //                                yOffset += yPosition
            //                                xPosition = 0
            //                                yPosition = 0
            //                                print("Прямоугольник перемещен на смещение: x=\(xOffset), y=\(yOffset)")
            //                                print(screenHeight*0.04)
            //                            }
            //                    )
            
        }
        
        .onAppear {
            getGameFramesPositions()
            shuffleArray()
            createFirstPresentedArray()
        }
        
    }
    
    func figureImage(type: Int) -> String {
        switch type {
        case 1:
            return "fig1_1"
        case 2:
            return "fig1_2"
        case 3:
            return "fig1_3"
        case 4:
            return "fig1_4"
        case 5:
            return "fig1_5"
        case 6:
            return "fig1_6"
        default:
            return "fig1_1"
        }
    }
    
    func figureSize(type: Int) -> CGFloat {
        switch type {
        case 1:
            return 0.04
        case 2:
            return 0.04
        case 3:
            return 0.08
        case 4:
            return 0.08
        case 5:
            return 0.08
        case 6:
            return 0.12
        default:
            return 0.04
        }
    }
    
    func figurePartsCoordinates(type: Int) -> [Pos] {
        switch type {
        case 1:
            return [Pos(x: 0, y: 0)]
        case 2:
            return [Pos(x: -17.5, y: 0),Pos(x: 17.5, y: 0)]
        case 3:
            return [Pos(x: 0, y: -17.5),Pos(x: 0, y: 17.5)]
        case 4:
            return [Pos(x: -17.5, y: -17.5),Pos(x: -17.5, y: 17.5),Pos(x: 17.5, y: 17.5)]
        case 5:
            return [Pos(x: -17.5, y: 17.5),Pos(x: 17.5, y: 17.5),Pos(x: 17.5, y: -17.5)]
        case 6:
            return [Pos(x: 0, y: -35),Pos(x: 0, y: 0),Pos(x: 0, y: 35)]
        default:
            return [Pos(x: 0, y: 0)]
        }
    }
    
    func shuffleArray() {
        figuresArrayForGame =  Array(figuresArray.shuffled().prefix(21))
    }
    
    func createFirstPresentedArray() {
        presentedFiguresArray = Array(figuresArrayForGame.prefix(3))
        for i in 0..<figuresCoordinates.count {
            presentedFiguresArray[i].xPosition = figuresCoordinates[i].x
            presentedFiguresArray[i].yPosition = figuresCoordinates[i].y
        }
    }
    
    func getGameFramesPositions() {
        for i in 0..<framePositions.count {
            for j in 0..<framePositions[i].count {
                gameFrames[i][j].xPosition = framePositions[i][j].x
                gameFrames[i][j].yPosition = framePositions[i][j].y
            }
        }
    }
    
}

#Preview {
    Game()
}
