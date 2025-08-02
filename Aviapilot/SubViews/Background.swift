//
//  Background.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI

struct Background: View {
    var backgroundNumber = 3
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let isLandscape = width > height
            if isLandscape {
                Image(whatBG())
                    .resizable()
                    .frame(width: height*1.2, height: width)
                    .rotationEffect(Angle(degrees: -90))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            } else {
               
                Image(whatBG())
                    .resizable()
                    .ignoresSafeArea()
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
            }
        }
    }
    
    func whatBG() -> String{
        switch backgroundNumber {
        case 0:
            return "background0"
        case 1:
            return "background1"
        case 2:
            return "background2"
        case 3:
            return "background3"
        case 4:
            return "background4"
        default:
            return "background1"
        }
    }
}
#Preview {
    Background()
}
