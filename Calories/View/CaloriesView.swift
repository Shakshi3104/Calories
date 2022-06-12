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
        NavigationView {
            List {
                HStack(spacing: 10) {
                    VStack(spacing: 5) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.consumptionEnergyOrange)
                        
                        HStack(spacing: 10) {
                            CalorieView(energyName: "Resting",
                                        energy: energy.resting,
                                        color: .consumptionEnergyOrange,
                                        textStyle: textStyle)
                            
                            Divider()
                            
                            CalorieView(energyName: "Active",
                                        energy: energy.active,
                                        color: .consumptionEnergyOrange,
                                        textStyle: textStyle)
                        }
                    }
                    Divider()
                    
                    VStack(spacing: 5) {
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                            .foregroundColor(.intakeEnergyGreen)
                    CalorieView(energyName: "Dietary",
                                energy: energy.dietary,
                                color: .intakeEnergyGreen,
                                textStyle: textStyle)
                    }
                }
                .padding()
            }
            .navigationTitle("Calories")
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

// MARK: - Preview
struct CalorieView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(energy: Energy(resting: 1500,
                                    active: 200,
                                    dietary: 1600))
    }
}
