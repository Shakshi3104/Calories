//
//  AdviceView.swift
//  Calories
//
//  Created by Mac mini M2 Pro on 2025/11/14.
//

import SwiftUI

@available(iOS 26.0, *)
struct AdviceView: View {
    var adviceViewModel: AdviceViewModel
    var currentNutrition: BasicNutrition
    var basicNutritionGoal: BasicNutritionGoal
    
    var body: some View {
        List {
            if adviceViewModel.isLoading {
                ProgressView {
                    Text("Thinking...")
                }
            } else if let advice = adviceViewModel.advice {
                VStack {
                    Text("\(advice.dietatySuggestion)")
                    Text("\(advice.exerciseSuggestion)")
                    Text("\(advice.generalComment)")
                }
            }
        }
        .task {
            await adviceViewModel.generateAdvice(currentNutrition: currentNutrition, basicNutritionGoal: basicNutritionGoal)
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        AdviceView(
            adviceViewModel: AdviceViewModel(),
            currentNutrition: BasicNutrition(protein: 30, carbohydrates: 100, fatTotal: 50),
        basicNutritionGoal: BasicNutritionGoal())
    } else {
        // Fallback on earlier versions
        EmptyView()
    }
}
