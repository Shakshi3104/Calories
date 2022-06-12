//
//  NutritionDetailView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/12.
//

import SwiftUI

struct NutritionDetailView: View {
    var basicNutrition: BasicNutrition
    
    private let basicNutritionGoal = BasicNutrition.goal()
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    RingView(value: Float(basicNutrition.protein) / Float(basicNutritionGoal.protein),
                             startColor: .proteinLightOrange,
                             endColor: .proteinOrange,
                             lineWidth: 30,
                             size: 250,
                             systemImageName: "circlebadge.2")
                    
                    RingView(value: Float(basicNutrition.carbohydrates) / Float(basicNutritionGoal.carbohydrates),
                             startColor: .carbohydratesLightBlue,
                             endColor: .carbohydratesBlue,
                             lineWidth: 30,
                             size: 188,
                             systemImageName: "speedometer")
                    
                    RingView(value: Float(basicNutrition.fatTotal) / Float(basicNutritionGoal.fatTotal),
                             startColor: .fatLightPurple,
                             endColor: .fatPurple,
                             lineWidth: 30,
                             size: 125,
                             systemImageName: "scalemass")
                }
                .frame(width: 300, height: 300)
                
                VStack(alignment: .leading, spacing: 20) {
                    BasicNutritionView(name: "Protein", value: basicNutrition.protein, goalValue: basicNutritionGoal.protein, color: .proteinOrange)
                    BasicNutritionView(name: "Carbohydrates", value: basicNutrition.carbohydrates, goalValue: basicNutritionGoal.carbohydrates, color: .carbohydratesBlue)
                    BasicNutritionView(name: "Fat", value: basicNutrition.fatTotal, goalValue: basicNutritionGoal.fatTotal, color: .fatPurple)
                }
                .padding()
            }
        }
    }
}

struct BasicNutritionView: View {
    var name: String
    var value: Int
    var goalValue: Int
    var color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(value)/\(goalValue)")
                        .foregroundColor(color)
                        .font(.system(.title, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                        .privacySensitive()
                    Text("g")
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


struct NutritionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionDetailView(basicNutrition: BasicNutrition(protein: 30, carbohydrates: 200, fatTotal: 20))
    }
}
