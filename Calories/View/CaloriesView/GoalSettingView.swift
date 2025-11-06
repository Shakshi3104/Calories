//
//  GoalSettingView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/13.
//

import SwiftUI

struct GoalSettingView: View {
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    
    var body: some View {
        List {
            Section {
                GoalField(name: "Protein", value: $basicNutritionGoal.protein,
                          systemImageName: "circlebadge.2", color: .proteinPink)
                GoalField(name: "Carbohydrates", value: $basicNutritionGoal.carbohydrates,
                          systemImageName: "speedometer", color: .carbohydratesBlue)
                GoalField(name: "Fat", value: $basicNutritionGoal.fatTotal,
                          systemImageName: "scalemass", color: .fatSkyBlue)
            } header: {
                Text("Nutrition Goal")
            }
            
        }
    }
}

struct GoalField: View {
    var name: String
    @Binding var value: Int
    
    var systemImageName: String
    var color: Color
     
    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .foregroundColor(color)
            Text(name)
            Spacer()
            TextField(name, value: $value, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GoalSettingView(basicNutritionGoal: BasicNutritionGoal())
    }
}
