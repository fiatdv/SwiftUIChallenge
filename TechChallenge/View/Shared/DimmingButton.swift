//
//  DimmingButton.swift
//  TechChallenge
//
//  Created by Felipe Gomez on 2/10/22.
//

import SwiftUI

struct DimmingButton: ButtonStyle {
    let category: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxHeight: 36)
            .background(ExpenseModel.backgroundColor(category))
            .opacity(configuration.isPressed ? 0.3 : 1.0)
            .foregroundColor(.white)
            .font(Font.system(.title2).bold())
            .cornerRadius(20)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

