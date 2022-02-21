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
                            color: .heathcareOrange)
                
                Divider()
                
                CalorieView(energyName: "Active",
                            energy: energy.active,
                            color: .heathcareOrange)
                
                Divider()
                
                CalorieView(energyName: "Dietary",
                            energy: energy.dietary,
                            color: .heathcareGreen)
                
                Divider()
                
                CalorieView(energyName: "Ingestible",
                            energy: energy.ingestible,
                            color: .heathcareIrisPurple)
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(energyName)
                .foregroundColor(color)
                .font(.caption)
            HStack(alignment: .bottom, spacing: 2) {
                Text("\(energy)")
                    .font(.system(.title3, design: .rounded).monospacedDigit())
                    .fontWeight(.medium)
                Text("kcal")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 2)
            }
        }
    }
}

// MARK: - Color extension
extension Color {
    static let heathcareOrange = Color(#colorLiteral(red: 1, green: 0.2862411141, blue: 9.264674009e-05, alpha: 1))
    static let heathcareGreen = Color(#colorLiteral(red: 0.2038900852, green: 0.7803977132, blue: 0.349026382, alpha: 1))
    static let heathcareIrisPurple = Color(#colorLiteral(red: 0.4508649707, green: 0.4899255633, blue: 0.95906955, alpha: 1))
}

// MARK: - Preview
struct CalorieView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(energy: Energy(resting: 1500,
                                    active: 200,
                                    dietary: 1600))
    }
}
