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
    @State private var hideFigureOpacity: CGFloat = 1
    @State private var presentedFiguresArray: [Figure] = [Figure(name: "", color: 1, type: 1)]
    @State private var isTouching: Bool = false
    @State private var figureSetOffset: CGFloat = 0
    @State private var selectedFigureSet = 0
    @State private var firstSetIndex = 0
    var body: some View {
        ZStack {
            Color(.asphalt).ignoresSafeArea()
            Background(backgroundNumber: 3)
            Image(.bottomFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.17)
                .overlay(
                    HStack {
                        ForEach(0..<7, id: \.self) { item in
                            Circle()
                                .fill(Color(.white))
                                .frame(height: item == selectedFigureSet ? screenHeight*0.01 : screenHeight*0.005)
                        }
                    }
                        .padding(.bottom, screenHeight*0.125)
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            ZStack {
                ForEach(0..<presentedFiguresArray.count, id: \.self) { index in
                    ZStack {
                        ForEach(0..<figurePartsCoordinates(type: presentedFiguresArray[index].type ).count, id: \.self) { item in
                            Image(figureImage(colorType: presentedFiguresArray[index].color))
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
                                            xPosition = value.translation.width + presentedFiguresArray[index].xPosition*screenHeight/932 + figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].x + correctOffst(type: presentedFiguresArray[index].type)[0]
                                            yPosition = value.translation.height + presentedFiguresArray[index].yPosition*screenHeight/932 +
                                            figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].y + correctOffst(type: presentedFiguresArray[index].type)[1]
                                        }
                                        .onEnded { value in
                                            xOffset += xPosition - figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].x - correctOffst(type: presentedFiguresArray[index].type)[0]
                                            yOffset += yPosition - figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].y - correctOffst(type: presentedFiguresArray[index].type)[1]
                                            xPosition = 0
                                            yPosition = 0
                                            print("Прямоугольник перемещен на смещение: x=\(xOffset), y=\(yOffset)")
                                            print(screenHeight*0.04)
                                            isTouching = false
                                            putFiguresOnBoard(posX: xOffset + xPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].x*screenHeight/932, posY: yOffset + yPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].y*screenHeight/932, figure: presentedFiguresArray[index])
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                xOffset = 0
                                                yOffset = 0
//                                            }
                                        }
                                )
                            
                        }
                    }
                    .offset(x: presentedFiguresArray[index].xPosition*screenHeight/932, y: presentedFiguresArray[index].yPosition*screenHeight/932)
                    .offset(x: figureSetOffset)
                    .mask(
                       Rectangle()
                        .frame(width: screenHeight*0.1, height: screenHeight*0.13)
                        .offset(x: presentedFiguresArray[index].xPosition*screenHeight/932, y: presentedFiguresArray[index].yPosition*screenHeight/932)
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
            
            ZStack {
                ForEach(0..<figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type ).count, id: \.self) { item in
                    Image(figureImage(colorType: presentedFiguresArray[selectedFigure].color))
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.04)
                        .offset(
                            x: xOffset + xPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].x*screenHeight/932,
                            y: yOffset + yPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].y*screenHeight/932
                        )
                        .opacity(0.6)
                }
                HStack {
                    Image(.redArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.05)
                        .scaleEffect(x: -1)
                        .onTapGesture {
                            changeFigureSet(direction: -1)
                        }
                    Spacer()
                    Image(.redArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.05)
                        .onTapGesture {
                            changeFigureSet(direction: 1)
                        }
                    
                }
                .frame(maxWidth: screenHeight*0.42)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom)
                
            }
            
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
        }
        
        .onAppear {
            getGameFramesPositions()
            shuffleArray()
            createFirstPresentedArray()
        }
        
    }
    
    func correctOffst(type: Int) -> [CGFloat] {
        switch type {
        case 1:
            return [0,0]
        case 2:
            return [15,0]
        case 3:
            return [0,15]
        case 4:
            return [15,-15]
        case 5:
            return [-15,-15]
        case 6:
            return [0,0]
        default:
            return [0,0]
        }
    }
    
    func putFiguresOnBoard(posX: CGFloat, posY: CGFloat, figure: Figure) {
        print("\(posX)")
        print("\(posY)")
        var framePositionX = 0
        var framePositionY = 0
        for i in 0..<framePositions.count {
            for j in 0..<framePositions[i].count {
                if posX <= (framePositions[i][j].x + 18) &&
                    posX >= framePositions[i][j].x - 18 &&
                    posY <= framePositions[i][j].y + 18 &&
                    posY >= framePositions[i][j].y - 18 {
                    framePositionX = i
                    framePositionY = j
                    break
                } else {
                    withAnimation(Animation.easeInOut(duration: 0.3)) {
                        xOffset = presentedFiguresArray[selectedFigure].xPosition
                        yOffset = presentedFiguresArray[selectedFigure].yPosition
                    }
                }
            }
        }
        switch figure.type {
        case 1:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
        case 2:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX][framePositionY+1].name = figureImage(colorType: figure.color)
        case 3:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX+1][framePositionY].name = figureImage(colorType: figure.color)
        case 4:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX][framePositionY+1].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX-1][framePositionY].name = figureImage(colorType: figure.color)
        case 5:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX][framePositionY-1].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX-1][framePositionY].name = figureImage(colorType: figure.color)
        case 6:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX-1][framePositionY].name = figureImage(colorType: figure.color)
            gameFrames[framePositionX+1][framePositionY].name = figureImage(colorType: figure.color)
        default:
            gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
        }

        
    }
    
    func updatePresentedArray() {
        presentedFiguresArray = Array(figuresArrayForGame[firstSetIndex...(firstSetIndex+2)])
        for i in 0..<figuresCoordinates.count {
            presentedFiguresArray[i].xPosition = figuresCoordinates[i].x
            presentedFiguresArray[i].yPosition = figuresCoordinates[i].y
        }
    }
    
    func changeFigureSet(direction: Double) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            figureSetOffset = direction*screenHeight*0.2
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            selectedFigureSet += Int(direction)
            if selectedFigureSet < 0 {
                selectedFigureSet = 6
            }
            if selectedFigureSet > 6 {
                selectedFigureSet = 0
            }
            firstSetIndex += Int(direction)*3
            if firstSetIndex < 0 {
                firstSetIndex = 18
            }
            if firstSetIndex > 18 {
                firstSetIndex = 0
            }
            updatePresentedArray()
            figureSetOffset = -direction*screenHeight*0.2
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                figureSetOffset = 0
            }
        }
    }
    
    func figureImage(colorType: Int) -> String {
        switch colorType {
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
