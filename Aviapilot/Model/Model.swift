//
//  Model.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import Foundation

struct GameFrame: Equatable {
    var name: String = "emptyRectangle"
    var xPosition: CGFloat = 0
    var yPosition: CGFloat = 0
}

struct Pos {
    var x: CGFloat
    var y: CGFloat
}

struct Figure {
    var name: String
    var color: Int
    var type: Int
    var xPosition: CGFloat = 0
    var yPosition: CGFloat = 0
    var opacity: CGFloat = 1
    var enable = true
}

struct PresentedFigures {
    var name: String
    var color: Int
    var type: Int
    var xPosition: CGFloat = 0
    var yPosition: CGFloat = 0
    var opacity: CGFloat = 1
    var enable = true
}

class Arrays {
    
    static var figuresCoordinates: [Pos] = [
        Pos(x: -100, y: 377),
        Pos(x: 0, y: 377),
        Pos(x: 100, y: 377),
    ]
    
    static var figuresArray: [Figure] = [
        Figure(name: "fig1_1", color: 1, type: 1),
        Figure(name: "fig1_2", color: 2, type: 1),
        Figure(name: "fig1_3", color: 3, type: 1),
        Figure(name: "fig1_4", color: 4, type: 1),
        Figure(name: "fig1_5", color: 5, type: 1),
        Figure(name: "fig1_6", color: 6, type: 1),
        Figure(name: "fig2_1", color: 1, type: 2),
        Figure(name: "fig2_2", color: 2, type: 2),
        Figure(name: "fig2_3", color: 3, type: 2),
        Figure(name: "fig2_4", color: 4, type: 2),
        Figure(name: "fig2_5", color: 5, type: 2),
        Figure(name: "fig2_6", color: 6, type: 2),
        Figure(name: "fig3_1", color: 1, type: 3),
        Figure(name: "fig3_2", color: 2, type: 3),
        Figure(name: "fig3_3", color: 3, type: 3),
        Figure(name: "fig3_4", color: 4, type: 3),
        Figure(name: "fig3_5", color: 5, type: 3),
        Figure(name: "fig3_6", color: 6, type: 3),
        Figure(name: "fig4_1", color: 1, type: 4),
        Figure(name: "fig4_2", color: 2, type: 4),
        Figure(name: "fig4_3", color: 3, type: 4),
        Figure(name: "fig4_4", color: 4, type: 4),
        Figure(name: "fig4_5", color: 5, type: 4),
        Figure(name: "fig4_6", color: 6, type: 4),
        Figure(name: "fig5_1", color: 1, type: 5),
        Figure(name: "fig5_2", color: 2, type: 5),
        Figure(name: "fig5_3", color: 3, type: 5),
        Figure(name: "fig5_4", color: 4, type: 5),
        Figure(name: "fig5_5", color: 5, type: 5),
        Figure(name: "fig5_6", color: 6, type: 5),
        Figure(name: "fig6_1", color: 1, type: 6),
        Figure(name: "fig6_2", color: 2, type: 6),
        Figure(name: "fig6_3", color: 3, type: 6),
        Figure(name: "fig6_4", color: 4, type: 6),
        Figure(name: "fig6_5", color: 5, type: 6),
        Figure(name: "fig6_6", color: 6, type: 6),
    ]
    
    static var gameFrames = [
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
       [ GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame(),GameFrame()],
    ]
    
    static var framePositions = [
        [Pos(x: -158, y: 64), Pos(x: -123, y: 64), Pos(x: -88, y: 64), Pos(x: -53, y: 64), Pos(x: -18, y: 64),Pos(x: 18, y: 64), Pos(x: 53, y: 64),Pos(x: 88, y: 64),Pos(x: 123, y: 64),Pos(x: 158, y: 64)],
        [Pos(x: -158, y: 99), Pos(x: -123, y: 99), Pos(x: -88, y: 99), Pos(x: -53, y: 99), Pos(x: -18, y: 99),Pos(x: 18, y: 99), Pos(x: 53, y: 99),Pos(x: 88, y: 99),Pos(x: 123, y: 99),Pos(x: 158, y: 99)],
        [Pos(x: -158, y: 134), Pos(x: -123, y: 134), Pos(x: -88, y: 134), Pos(x: -53, y: 134), Pos(x: -18, y: 134),Pos(x: 18, y: 134), Pos(x: 53, y: 134),Pos(x: 88, y: 134),Pos(x: 123, y: 134),Pos(x: 158, y: 134)],
        [Pos(x: -158, y: 169), Pos(x: -123, y: 169), Pos(x: -88, y: 169), Pos(x: -53, y: 169), Pos(x: -18, y: 169),Pos(x: 18, y: 169), Pos(x: 53, y: 169),Pos(x: 88, y: 169),Pos(x: 123, y: 169),Pos(x: 158, y: 169)],
        [Pos(x: -158, y: 204), Pos(x: -123, y: 204), Pos(x: -88, y: 204), Pos(x: -53, y: 204), Pos(x: -18, y: 204),Pos(x: 18, y: 204), Pos(x: 53, y: 204),Pos(x: 88, y: 204),Pos(x: 123, y: 204),Pos(x: 158, y: 204)],
        [Pos(x: -158, y: 239), Pos(x: -123, y: 239), Pos(x: -88, y: 239), Pos(x: -53, y: 239), Pos(x: -18, y: 239),Pos(x: 18, y: 239), Pos(x: 53, y: 239),Pos(x: 88, y: 239),Pos(x: 123, y: 239),Pos(x: 158, y: 239)],
        [Pos(x: -158, y: 274), Pos(x: -123, y: 274), Pos(x: -88, y: 274), Pos(x: -53, y: 274), Pos(x: -18, y: 274),Pos(x: 18, y: 274), Pos(x: 53, y: 274),Pos(x: 88, y: 274),Pos(x: 123, y: 274),Pos(x: 158, y: 274)],
    ]
}
