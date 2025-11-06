//
//  CalorieDetailView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/12.
//

import SwiftUI

struct CalorieDetailView: View {
    var energy: Energy
    
    var body: some View {
        ScrollView {
            VStack {
                let value = energy.dietary > 0 ? Float(energy.dietary) / Float(energy.active + energy.resting) : 0.0
                RingView(value: value,
                         startColor: .intakeEnergyGreen,
                         endColor: .intakeEnergyLightGreen,
                         lineWidth: 30,
                         size: 250,
                         systemImageName: "takeoutbag.and.cup.and.straw")
                .frame(width: 300, height: 300)
                
                VStack(alignment: .leading, spacing: 20) {
                    EnergyView(name: "Ingestible", value: energy.ingestible, color: .irisPurple)
                    EnergyView(name: "Resting", value: energy.resting, color: .consumptionEnergyOrange)
                    EnergyView(name: "Active", value: energy.active, color: .consumptionEnergyOrange)
                    EnergyView(name: "Dietary", value: energy.dietary, color: .intakeEnergyGreen)
                }
                .padding()
            }
        }
    }
}

struct EnergyView: View {
    var name: String
    var value: Int
    var color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(value)")
                        .foregroundColor(color)
                        .font(.system(.title, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                        .privacySensitive()
                    Text("KCAL")
                        .foregroundColor(color)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.medium)
                        .padding(.bottom, 2)
                }
            }
            
            Spacer()
        }
    }
}

struct CalorieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalorieDetailView(energy: Energy(resting: 1500,
                                         active: 200,
                                         dietary: 2000))
        .preferredColorScheme(.dark)
        .previewInterfaceOrientation(.portrait)
        
    }
}
