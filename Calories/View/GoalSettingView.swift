//
//  GoalSettingView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/13.
//

import SwiftUI

struct GoalSettingView: View {
    @Environment(\.dismiss) private var dismiss
    
//    @State private var proteinGoal: Int = BasicNutrition.goal().protein
//    @State private var carbohydratesGoal: Int = BasicNutrition.goal().carbohydrates
//    @State private var fatTotalGoal: Int = BasicNutrition.goal().fatTotal
    
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    GoalField(name: "Protein", value: $basicNutritionGoal.protein,
                              systemImageName: "circlebadge.2", color: .proteinOrange)
                    GoalField(name: "Carbohydrates", value: $basicNutritionGoal.carbohydrates,
                              systemImageName: "speedometer", color: .carbohydratesBlue)
                    GoalField(name: "Fat", value: $basicNutritionGoal.fatTotal,
                              systemImageName: "scalemass", color: .fatPurple)
                } header: {
                    Text("Nutrition Goal")
                }

            }
            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        // set nutrition goal
//                        UserDefaults.standard.set(proteinGoal, forKey: PROTEIN_GOAL_KEY_NAME)
//                        UserDefaults.standard.set(carbohydratesGoal, forKey: CARBOHYDRATES_GOAL_KEY_NAME)
//                        UserDefaults.standard.set(fatTotalGoal, forKey: FAT_TOTAL_GOAL_KEY_NAME)
//
                        dismiss()
                    } label: {
                        Text("Done")
                    }

                }
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
