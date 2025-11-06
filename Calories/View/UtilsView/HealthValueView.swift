//
//  CalorieView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI

// MARK: - CalorieView
struct CalorieView: View {
    var energyName: String
    var energy: Int
    var color: Color
    var textStyle: Font.TextStyle = .title3
    
    var body: some View {
        HealthValueView(name: energyName, value: energy, unit: "kcal", color: color, textStyle: textStyle)
    }
}

// MARK: - Health value view
struct HealthValueView: View {
    var name: String
    var value: Int
    var unit: String
    var color: Color
    var textStyle: Font.TextStyle = .title3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .foregroundColor(color)
                .font(.caption)
            HStack(alignment: .bottom, spacing: 2) {
                Text("\(value)")
                    .font(.system(textStyle, design: .rounded).monospacedDigit())
                    .fontWeight(.medium)
                Text(unit)
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 2)
            }
        }
    }
}
