//
//  AdviceView.swift
//  Calories
//
//  Created by Mac mini M2 Pro on 2025/11/14.
//

import SwiftUI

/// A view with animations to show while waiting for an AI response.
struct AIThinkingView: View {
    private let phrases = ["Analyzing data...", "Crafting advice...", "Finding suggestions..."]
    @State private var currentPhrase: String
    @State private var isAnimating = false

    init() {
        _currentPhrase = State(initialValue: phrases.first ?? "Thinking...")
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundStyle(.tint)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 10 : -5))
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isAnimating
                )

            Text(currentPhrase)
                .font(.headline)
                .foregroundColor(.secondary)
                .transition(.opacity.animation(.easeInOut))
        }
        .task {
            isAnimating = true
            
            // Cycle through text every 2 seconds
            var index = 0
            while !Task.isCancelled {
                withAnimation {
                    currentPhrase = phrases[index]
                }
                index = (index + 1) % phrases.count
                try? await Task.sleep(for: .seconds(2))
            }
        }
    }
}


@available(iOS 26.0, *)
struct AdviceView: View {
    @StateObject var adviceViewModel: AdviceViewModel
    var currentNutrition: BasicNutrition
    var basicNutritionGoal: BasicNutritionGoal
    
    var body: some View {
        List {
            if adviceViewModel.isLoading {
                HStack {
                    Spacer()
                    AIThinkingView()
                    Spacer()
                }
                .listRowBackground(Color.clear)
            } else {
                Section {
                    VStack {
                        // TODO: Add walking step or active energy
                        
                        HStack(spacing: 10) {
                            HealthValueView(name: "Protein", value: currentNutrition.protein, unit: "g", color: .proteinPink)
                            
                            Divider()
                            
                            HealthValueView(name: "Fat", value: currentNutrition.fatTotal, unit: "g", color: .fatSkyBlue)
                            
                            Divider()
                            
                            HealthValueView(name: "Carbohydrates", value: currentNutrition.carbohydrates, unit: "g", color: .carbohydratesBlue)
                        }
                    }
                }
                if let advice = adviceViewModel.advice {
                    Section {
                        Text(advice.generalComment)
                    }
                    
                    Section("Dietary") {
                        Text(advice.dietarySuggestion)
                    }
                    
                    Section("Exercise") {
                        Text(advice.exerciseSuggestion)
                    }
                } else {
                    Text("Unable to generate advice. Please try again later.")
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
