//
//  CalorieView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI

// MARK: - CalorieView
struct CaloriesView: View {
    var energy: Energy
    var textStyle: Font.TextStyle = .title3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.heathcareOrange)
                Text("Energy")
                    .foregroundColor(.heathcareOrange)
            }
            
            HStack(spacing: 10) {
                CalorieView(energyName: "Resting",
                            energy: energy.resting,
                            color: .heathcareOrange,
                            textStyle: textStyle)
                
                Divider()
                
                CalorieView(energyName: "Active",
                            energy: energy.active,
                            color: .heathcareOrange,
                            textStyle: textStyle)
                
                Divider()
                
                CalorieView(energyName: "Dietary",
                            energy: energy.dietary,
                            color: .heathcareGreen,
                            textStyle: textStyle)
                
                Divider()
                
                CalorieView(energyName: "Ingestible",
                            energy: energy.ingestible,
                            color: .heathcareIrisPurple,
                            textStyle: textStyle)
            }
            .frame(height: 70)
        }
    }
}

// MARK: - CalorieView
struct CalorieView: View {
    var energyName: String
    var energy: Int
    var color: Color
    var textStyle: Font.TextStyle = .title3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(energyName)
                .foregroundColor(color)
                .font(.caption)
            HStack(alignment: .bottom, spacing: 2) {
                Text("\(energy)")
                    .font(.system(textStyle, design: .rounded).monospacedDigit())
                    .fontWeight(.medium)
                Text("kcal")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 2)
            }
        }
    }
}

// MARK: - Preview
struct CalorieView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(energy: Energy(resting: 1500,
                                    active: 200,
                                    dietary: 1600))
    }
}
