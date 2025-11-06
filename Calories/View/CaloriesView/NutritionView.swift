//
//  NutritionTopView.swift
//  Calories
//
//  Created by Mac mini M2 Pro on 2025/11/06.
//

import SwiftUI

struct NutritionView: View {
    var basicNutrition: BasicNutrition
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    private let textStyle: Font.TextStyle = .body

    var body: some View {
        NavigationView {
            List {
                Section("Goal") {
                    NavigationLink {
                        NutritionDetailView(basicNutrition: basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    } label: {
                        NutritionTopView(basicNutrition: basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    }
                }
                
                Section("PFCBalance") {
                    PFCBalanceTopView(basicNutrition: basicNutrition)
                }
            }
        }
    }
}

#Preview {
    NutritionView(basicNutrition: BasicNutrition(protein: 30, carbohydrates: 200, fatTotal: 20), basicNutritionGoal: BasicNutritionGoal())
}
