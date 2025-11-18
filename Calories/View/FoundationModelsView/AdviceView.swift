//
//  AdviceView.swift
//  Calories
//
//  Created by Mac mini M2 Pro on 2025/11/14.
//

import SwiftUI

@available(iOS 26.0, *)
struct AdviceView: View {
    @StateObject var adviceViewModel: AdviceViewModel
    var currentNutrition: BasicNutrition
    var basicNutritionGoal: BasicNutritionGoal
    
    var body: some View {
        List {
            if adviceViewModel.isLoading {
                ProgressView {
                    Text("Thinking...")
                }
            } else {
                if let advice = adviceViewModel.advice {
                    Section("Dietary") {
                        Text("\(advice.dietarySuggestion)")
                    }
                    
                    Section("Exercise") {
                        Text("\(advice.exerciseSuggestion)")
                    }
                    
                    Section {
                        Text("\(advice.generalComment)")
                    }
                } else {
                    Text("Unable to generate advice. Please try again later.")
                }
            }
        }
        .task {
            if adviceViewModel.isFoundationModelsAvailable() {
                await adviceViewModel.generateAdvice(currentNutrition: currentNutrition, basicNutritionGoal: basicNutritionGoal)
            }
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
