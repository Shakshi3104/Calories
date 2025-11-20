//
//  ContentView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI

@available(iOS 26.0, *)
struct ContentView: View {
    @StateObject var viewModel: CaloriesViewModel
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    var body: some View {
        TabView {
            Tab("Summary", systemImage: "flame") {
                CaloriesView(viewModel: viewModel, basicNutritionGoal: basicNutritionGoal)
            }
            
            Tab("Goal", systemImage: "gear") {
                GoalSettingView(basicNutritionGoal: basicNutritionGoal)
            }
            
            if #available(iOS 26, *) {
                Tab("Ask AI", systemImage: "sparkles", role: .search) {
                    AdviceView(adviceViewModel: AdviceViewModel(), currentNutrition: viewModel.basicNutrition,
                    basicNutritionGoal: basicNutritionGoal)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: CaloriesViewModel(),
                    basicNutritionGoal: BasicNutritionGoal())
    }
}
