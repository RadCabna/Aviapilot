//
//  Game.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Game: View {
    @EnvironmentObject var coordinator: Coordinator
    @AppStorage("levelNumber") var levelNumber: Int = 1
    @AppStorage("planeSet") var planeSet = 0
    @AppStorage("sound2") var sound2 = true
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
    @State private var hideFigureOpacity: CGFloat = 0
    @State private var presentedFiguresArray: [Figure] = [Figure(name: "", color: 1, type: 1)]
    @State private var isTouching: Bool = false
    @State private var figureSetOffset: CGFloat = 0
    @State private var selectedFigureSet = 0
    @State private var firstSetIndex = 0
    @State private var planesArray = Arrays.planesArray1
    @State private var youWin = false
    @State private var youLose = false
    @State private var checkPlaneCanRideTimer: Timer?
    @State private var finishPlaneCount: Int = 0
    @State private var timer: Timer?
    @State private var elapsedTime: Int = 60
    let verticalOffsetArray: [CGFloat] = [64, 99, 134, 169, 204, 239, 274]
    var body: some View {
        ZStack {
            Color(.asphalt).ignoresSafeArea()
            Background(backgroundNumber: 3)
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
                ForEach(0..<planesArray.count, id:\.self) { item in
                    AnimatePlane(isRiding: $planesArray[item].ride, image: planesArray[item].name)
                        .rotationEffect(Angle(degrees: planesArray[item].rotation))
                        .offset(x: planesArray[item].xPosition, y: planesArray[item].yPosition)
                        .onTapGesture {
                            planesArray[item].yPosition += 10
                        }
                }
            }
            
            Image(.bottomFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.17)
                .overlay(
                    HStack {
                        ForEach(0..<10, id: \.self) { item in
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
                                .opacity(presentedFiguresArray[index].opacity)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if presentedFiguresArray[index].opacity == 1 {
                                                hideFigureOpacity = 1
                                                if !isTouching {
                                                    selectedFigure = index
                                                    isTouching = true
                                                    
                                                }
                                                xPosition = value.translation.width + presentedFiguresArray[index].xPosition*screenHeight/932 + figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].x + correctOffst(type: presentedFiguresArray[index].type)[0]
                                                yPosition = value.translation.height + presentedFiguresArray[index].yPosition*screenHeight/932 +
                                                figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].y + correctOffst(type: presentedFiguresArray[index].type)[1]
                                            }
                                        }
                                        .onEnded { value in
                                            if presentedFiguresArray[index].opacity == 1 {
                                                xOffset += xPosition - figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].x - correctOffst(type: presentedFiguresArray[index].type)[0]
                                                yOffset += yPosition - figurePartsCoordinates(type: presentedFiguresArray[index].type )[item].y - correctOffst(type: presentedFiguresArray[index].type)[1]
                                                xPosition = 0
                                                yPosition = 0
                                                print(screenHeight*0.04)
                                                isTouching = false
                                                putFiguresOnBoard(posX: xOffset + xPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].x*screenHeight/932, posY: yOffset + yPosition + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].y*screenHeight/932, figure: presentedFiguresArray[index])
                                                
                                                xOffset = 0
                                                yOffset = 0
                                                hideFigureOpacity = 0
                                            }
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
                ForEach(0..<figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type ).count, id: \.self) { item in
                    Image(figureImage(colorType: presentedFiguresArray[selectedFigure].color))
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.04)
                        .offset(
                            x: xOffset*screenHeight/932 + xPosition*screenHeight/932 + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].x*screenHeight/932,
                            y: yOffset*screenHeight/932 + yPosition*screenHeight/932 + figurePartsCoordinates(type: presentedFiguresArray[selectedFigure].type )[item].y*screenHeight/932
                        )
                        .opacity(hideFigureOpacity)
                }
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
            if levelNumber < 5 {
                HStack {
                    Image(.fence5)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.03)
                    Spacer()
                        .frame(width: screenHeight*0.24)
                    Image(.fence5)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.03)
                }
                .offset(y: screenHeight*0.025)
            }
            if levelNumber < 10 {
                HStack {
                    Image(.fence10)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.03)
                    Spacer()
                        .frame(width: screenHeight*0.31)
                    Image(.fence10)
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight*0.03)
                }
                .offset(y: screenHeight*0.025)
            }
            
            Image(.timerFrame)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.04)
                .overlay(
                    Text(String(format: "%02d:%02d", 0, elapsedTime))
                        .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.025))
                        .foregroundStyle(Color.white)
                        .padding(.bottom, screenHeight*0.005)
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, screenHeight*0.045)
                .padding(.bottom, screenHeight*0.1)
            
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
                        Text("LEVEL \(levelNumber)")
                            .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.05))
                            .foregroundStyle(Color.white)
                            .padding(.bottom, screenHeight*0.005)
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
                
            
            if youWin {
                WinView(time: $elapsedTime, planeCount: $finishPlaneCount)
            }
            if youLose {
                LoseView()
            }
        }
        
        .onChange(of: gameFrames) { _ in
            for i in 0..<planesArray.count {
                planesArray[i].road = createRoadForColor(color: planesArray[i].color)
                    
            }
//            roadArray = createRoadForColor(color: 1)
//            print(roadArray)
            for i in 0..<planesArray.count {
                checkPosibleRoad(index: i)
            }
            
        }
        
        .onChange(of: elapsedTime) { _ in
            if elapsedTime <= 0 {
                stopGameTimer()
                youLose = true
            }
        }
        
        .onChange(of: planesArray) { _ in
            for i in 0..<planesArray.count {
                checkPosibleRoad(index: i)
                if planesArray[i].yPosition == 274*screenHeight/932 {
                        planesArray[i].rideTimer?.invalidate()
                    withAnimation(Animation.easeInOut(duration: 2)) {
                        planesArray[i].yPosition = 350*screenHeight/932
                    }
                    planesArray[i].finish = true
                    finishPlaneCount += 1
                }
            }
            if finishPlaneCount == planesArray.count {
                youWin = true
                stopGameTimer()
            }
        }
        
        .onAppear {
            updateLevel()
            updatePlaneSkin()
            startGameTimer()
            getGameFramesPositions()
            shuffleArray()
            createFirstPresentedArray()
            cretePlanesOffsets()
            startPlaneRidingToZero()
        }
        
    }
    
    func updatePlaneSkin() {
        switch planeSet {
        case 0:
            for i in 0..<planesArray.count {
                let originalString = planesArray[i].name
                var stringArray = Array(originalString)
                stringArray[5] = "1"
                planesArray[i].name = String(stringArray)
            }
        case 1:
            for i in 0..<planesArray.count {
                let originalString = planesArray[i].name
                var stringArray = Array(originalString)
                stringArray[5] = "2"
                planesArray[i].name = String(stringArray)
            }
        case 2:
            for i in 0..<planesArray.count {
                let originalString = planesArray[i].name
                var stringArray = Array(originalString)
                stringArray[5] = "3"
                planesArray[i].name = String(stringArray)
            }
        case 3:
            for i in 0..<planesArray.count {
                let originalString = planesArray[i].name
                var stringArray = Array(originalString)
                stringArray[5] = "4"
                planesArray[i].name = String(stringArray)
            }
        case 4:
            for i in 0..<planesArray.count {
                let originalString = planesArray[i].name
                var stringArray = Array(originalString)
                stringArray[5] = "5"
                planesArray[i].name = String(stringArray)
            }
        default:
            for i in 0..<planesArray.count {
                let originalString = planesArray[i].name
                var stringArray = Array(originalString)
                stringArray[5] = "1"
                planesArray[i].name = String(stringArray)
            }
        }
    }
    
    func updateLevel() {
        switch levelNumber {
        case 1:
            planesArray = Arrays.planesArray1
        case 2:
            planesArray = Arrays.planesArray2
        case 3:
            planesArray = Arrays.planesArray3
        case 4:
            planesArray = Arrays.planesArray4
        case 5:
            planesArray = Arrays.planesArray5
        case 6:
            planesArray = Arrays.planesArray6
        case 7:
            planesArray = Arrays.planesArray7
        case 8:
            planesArray = Arrays.planesArray8
        case 9:
            planesArray = Arrays.planesArray9
        case 10:
            planesArray = Arrays.planesArray10
        default:
            planesArray = Arrays.allPlanesArray.randomElement() ?? Arrays.planesArray10
        }
    }
    
    func startGameTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if elapsedTime > 0 {
                elapsedTime -= 1
            }
        }
    }
    
    func stopGameTimer() {
        timer?.invalidate()
        timer = nil
        
    }
    
    func startCheckPlaneCanRideTimer() {
        if !planesArray.contains(where: {$0.yPosition == 0}) {
            for i in 0..<planesArray.count {
                checkPlaneCanRideTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                   planeRideToZero(index: i)
                }
            }
        } else {
            for i in 0..<planesArray.count {
                planesArray[i].rideTimer?.invalidate()
                planesArray[i].rideTimer = nil
            }
        }
    }
    
    func startPlaneRidingToZero() {
        var delay: Double = 0
        for i in 0..<planesArray.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1+delay) {
                planeRideToZero(index: i)
                delay += 1
            }
        }
    }
    
    func cretePlanesOffsets() {
        var plusOffset: CGFloat = 20
        for i in 0..<planesArray.count {
            planesArray[i].yPosition -= plusOffset
            plusOffset += 100
        }
    }
    
    func planeRideToZero(index: Int) {
        if !planesArray.contains(where: {$0.yPosition == 0}) {
            planesArray[index].rideTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                withAnimation(Animation.linear(duration: 0.1)) {
                    if planesArray[index].yPosition < 0 && !planesArray.contains(where: {$0.yPosition == 0}) {
                        planesArray[index].yPosition += 10
                    }
                }
            }
        }
    }
    
    func planeRideOnGameField(index: Int) {
//        var planeRow = 0
        var startPositionIndex: Int = 0
//        roadArray = createRoadForColor(color: planesArray[index].color)
        planesArray[index].rideTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//            planeRow = verticalOffsetArray.firstIndex(where: {$0 == planesArray[index].yPosition}) ?? 0
            if !planesArray[index].road.isEmpty {
                planeRideAnimation(index: index, row: planesArray[index].road[startPositionIndex].row, col: planesArray[index].road[startPositionIndex].col)
            }
            if startPositionIndex < planesArray[index].road.count-1 {
                startPositionIndex += 1
            }
            print(startPositionIndex)
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
    
    func createPlaneRoarArray(item: Int) {
        for i in 0..<gameFrames.count {
            for j in 0..<gameFrames[i].count {
                if gameFrames[i][j].xPosition == planesArray[item].xPosition && gameFrames[i][j].yPosition == planesArray[item].yPosition {
                    planesArray[item].planeRow = i
                    planesArray[item].planeCol = j
                }
            }
        }
        if gameFrames[planesArray[item].planeRow+1][planesArray[item].planeCol].color ==  planesArray[item].color {
            planesArray[item].road.append(PlaneRoad(row: planesArray[item].planeRow+1, col: planesArray[item].planeCol))
        }
        for i in planesArray[item].planeRow..<gameFrames.count {
//          if gameFrames
        }
    }
    
    func checkPosibleRoad(index: Int) {
        let planeColor = planesArray[index].color
        var row = 0
        if planesArray[index].xPosition == 0 && planesArray[index].yPosition == 0 {
            for j in 0..<gameFrames[row].count {
               if gameFrames[row][j].color == planeColor {
                    planeRideAnimation(index: index, row: row, col: j)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                       planeRideOnGameField(index: index)
                   }
                   break
                }
            }
        }
    }
    
    func planeRideAnimation(index: Int, row: Int, col: Int) {
        let planeIndex = planesArray.firstIndex(where: {$0.id == planesArray[index].id}) ?? 0
            if planesArray[index].xPosition - gameFrames[row][col].xPosition > 0 {
                withAnimation(Animation.easeInOut(duration: 1)) {
                    planesArray[planeIndex].rotation = 90
                }
            } else if planesArray[index].xPosition - gameFrames[row][col].xPosition < 0 {
                withAnimation(Animation.easeInOut(duration: 1)) {
                    planesArray[planeIndex].rotation = -90
                }
            } else {
                planesArray[planeIndex].rotation = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(Animation.easeInOut(duration: 1)) {
                    planesArray[planeIndex].xPosition = gameFrames[row][col].xPosition
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        planesArray[planeIndex].rotation = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(Animation.easeInOut(duration: 1)) {
                            if planesArray[index].yPosition < 270 {
                                planesArray[planeIndex].yPosition = gameFrames[row][col].yPosition
                            }
                        }
                    }
                }
            }
        }
    
    func putFiguresOnBoard(posX: CGFloat, posY: CGFloat, figure: Figure) {
        print("\(posX)")
        print("\(posY)")
        var selectedFigureIndex = 0
        var positionFind = false
        var framePositionX = 0
        var framePositionY = 0
        selectedFigureIndex = figuresArrayForGame.firstIndex(where: {$0.name == figure.name}) ?? 0
        for i in 0..<framePositions.count {
            for j in 0..<framePositions[i].count {
                if posX*screenHeight/932 <= (framePositions[i][j].x + 18)*screenHeight/932 &&
                    posX*screenHeight/932 >= (framePositions[i][j].x - 18)*screenHeight/932 &&
                    posY*screenHeight/932 <= (framePositions[i][j].y + 18)*screenHeight/932 &&
                    posY*screenHeight/932 >= (framePositions[i][j].y - 18)*screenHeight/932 {
                    framePositionX = i
                    framePositionY = j
                    positionFind = true
                    print("yes")
                    break
                    
                }
            }
        }
        switch figure.type {
        case 1:
            hideFigureOpacity = 0
            if positionFind &&
                framePositionY >= 0 &&
                framePositionY <= 9 &&
                framePositionX >= 0 &&
                framePositionX <= 6 &&
                gameFrames[framePositionX][framePositionY].name == "emptyRectangle" {
                gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY].color = figure.color
                figuresArrayForGame[selectedFigureIndex].opacity = 0.4
                updatePresentedArray()
            }
        case 2:
            hideFigureOpacity = 0
            if positionFind &&
                framePositionY >= 0 &&
                framePositionY <= 8 &&
                framePositionX >= 0 &&
                framePositionX <= 6 &&
                gameFrames[framePositionX][framePositionY].name == "emptyRectangle" &&
                gameFrames[framePositionX][framePositionY+1].name == "emptyRectangle" {
                gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY+1].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY].color = figure.color
                gameFrames[framePositionX][framePositionY+1].color = figure.color
                figuresArrayForGame[selectedFigureIndex].opacity = 0.4
                updatePresentedArray()
            }
        case 3:
            if positionFind &&
                framePositionY >= 0 &&
                framePositionY <= 9 &&
                framePositionX >= 0 &&
                framePositionX <= 5 &&
                gameFrames[framePositionX][framePositionY].name == "emptyRectangle" &&
                gameFrames[framePositionX+1][framePositionY].name == "emptyRectangle"{
                gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX+1][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY].color = figure.color
                gameFrames[framePositionX+1][framePositionY].color = figure.color
                figuresArrayForGame[selectedFigureIndex].opacity = 0.4
                updatePresentedArray()
            }
        case 4:
            if positionFind &&
                framePositionY >= 0 &&
                framePositionY <= 8 &&
                framePositionX >= 1 &&
                framePositionX <= 6 &&
                gameFrames[framePositionX][framePositionY].name == "emptyRectangle" &&
                gameFrames[framePositionX][framePositionY+1].name == "emptyRectangle" &&
                gameFrames[framePositionX-1][framePositionY].name == "emptyRectangle" {
                gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY+1].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX-1][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY].color = figure.color
                gameFrames[framePositionX][framePositionY+1].color = figure.color
                gameFrames[framePositionX-1][framePositionY].color = figure.color
                figuresArrayForGame[selectedFigureIndex].opacity = 0.4
                updatePresentedArray()
            }
        case 5:
            if positionFind &&
                framePositionY >= 1 &&
                framePositionY <= 9 &&
                framePositionX >= 1 &&
                framePositionX <= 6 &&
                gameFrames[framePositionX][framePositionY].name == "emptyRectangle" &&
                gameFrames[framePositionX][framePositionY-1].name == "emptyRectangle" &&
                gameFrames[framePositionX-1][framePositionY].name == "emptyRectangle" {
                gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY-1].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX-1][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY].color = figure.color
                gameFrames[framePositionX][framePositionY-1].color = figure.color
                gameFrames[framePositionX-1][framePositionY].color = figure.color
                figuresArrayForGame[selectedFigureIndex].opacity = 0.4
                updatePresentedArray()
            }
        case 6:
            if positionFind &&
                framePositionY >= 0 &&
                framePositionY <= 9 &&
                framePositionX >= 1 &&
                framePositionX <= 5 &&
                gameFrames[framePositionX][framePositionY].name == "emptyRectangle" &&
                gameFrames[framePositionX-1][framePositionY].name == "emptyRectangle" &&
                gameFrames[framePositionX+1][framePositionY].name == "emptyRectangle" {
                gameFrames[framePositionX][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX-1][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX+1][framePositionY].name = figureImage(colorType: figure.color)
                gameFrames[framePositionX][framePositionY].color = figure.color
                gameFrames[framePositionX-1][framePositionY].color = figure.color
                gameFrames[framePositionX+1][framePositionY].color = figure.color
                figuresArrayForGame[selectedFigureIndex].opacity = 0.4
                updatePresentedArray()
            }
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
                selectedFigureSet = 9
            }
            if selectedFigureSet > 9 {
                selectedFigureSet = 0
            }
            firstSetIndex += Int(direction)*3
            if firstSetIndex < 0 {
                firstSetIndex = 27
            }
            if firstSetIndex > 27 {
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
        figuresArrayForGame =  Array(figuresArray.shuffled().prefix(30))
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
    
    func createRoadForColor(color: Int) -> [PlaneRoad]{
       var road: [PlaneRoad] = []
        for i in 0..<gameFrames.count {
            for j in 0..<gameFrames[i].count {
                if (i > 2 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color &&
                    gameFrames[i-2][j].color == color &&
                    gameFrames[i-3][j].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j)) &&
                    !road.contains(PlaneRoad(row: i-3, col: j)) {
                    road.append(PlaneRoad(row: i-3, col: j))
                    road.append(PlaneRoad(row: i-2, col: j))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 1 && j > 0 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color &&
                    gameFrames[i-1][j-1].color == color &&
                    gameFrames[i-2][j-1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j-1)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j-1)) {
                    road.append(PlaneRoad(row: i-2, col: j-1))
                    road.append(PlaneRoad(row: i-1, col: j-1))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 1 && j > 0 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i][j-1].color == color &&
                    gameFrames[i-1][j-1].color == color &&
                    gameFrames[i-2][j-1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i, col: j-1)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j-1)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j-1)) {
                    road.append(PlaneRoad(row: i-2, col: j-1))
                    road.append(PlaneRoad(row: i-1, col: j-1))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 1 && j > 0 && j < 10 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color &&
                    gameFrames[i-2][j].color == color &&
                    gameFrames[i-2][j+1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j+1)) {
                    road.append(PlaneRoad(row: i-2, col: j+1))
                    road.append(PlaneRoad(row: i-2, col: j))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 1 && j > 0 && j < 10 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color &&
                    gameFrames[i-1][j+1].color == color &&
                    gameFrames[i-2][j+1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j+1)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j+1)) {
                    road.append(PlaneRoad(row: i-2, col: j+1))
                    road.append(PlaneRoad(row: i-1, col: j+1))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 1 && j > 0 && j < 10 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i][j+1].color == color &&
                    gameFrames[i-1][j+1].color == color &&
                    gameFrames[i-2][j+1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j+1)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j+1)) {
                    road.append(PlaneRoad(row: i-2, col: j+1))
                    road.append(PlaneRoad(row: i-1, col: j+1))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 0 && j > 0 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i][j-1].color == color &&
                    gameFrames[i-1][j-1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i, col: j-1)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j-1)) {
                    road.append(PlaneRoad(row: i-1, col: j-1))
                    road.append(PlaneRoad(row: i, col: j-1))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 0 && j > 0 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color &&
                    gameFrames[i-1][j-1].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j-1)) {
                    road.append(PlaneRoad(row: i-1, col: j-1))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 1 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color &&
                    gameFrames[i-2][j].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) &&
                    !road.contains(PlaneRoad(row: i-2, col: j)) {
                    road.append(PlaneRoad(row: i-2, col: j))
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 0 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) &&
                    !road.contains(PlaneRoad(row: i-1, col: j)) {
                    road.append(PlaneRoad(row: i-1, col: j))
                    road.append(PlaneRoad(row: i, col: j))
                }
                if (i > 0 &&
                    gameFrames[i][j].color == color &&
                    gameFrames[i-1][j].color == color) &&
                    !road.contains(PlaneRoad(row: i, col: j)) {
                    road.append(PlaneRoad(row: i, col: j))
                }
               
            }
        }
        return road
    }
    
}

#Preview {
    Game()
}
