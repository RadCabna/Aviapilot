//
//  Buttons.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 06.08.2025.
//

import SwiftUI

struct Buttons: View {
    var image = "settingsButton"
    var text: String = "settings"
    var size: CGFloat = 1
    var body: some View {
        VStack(spacing: 0) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight*0.09*size)
            Text(text)
                .font(Font.custom("PaytoneOne-Regular", size: screenHeight*0.02*size))
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    Buttons()
}
