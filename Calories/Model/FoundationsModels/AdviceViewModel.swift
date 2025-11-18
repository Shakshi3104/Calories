//
//  AdviceViewModel.swift
//  Calories
//
//  Created by Mac mini M2 Pro on 2025/11/14.
//

import Foundation
import FoundationModels

@available(iOS 26.0, *)
@MainActor
class AdviceViewModel: ObservableObject {
    @Published var advice: DailyAdvice?
    @Published var isLoading: Bool = false
    
    func generateAdvice(currentNutrition: BasicNutrition, basicNutritionGoal: BasicNutritionGoal) async {
        isLoading = true
        defer { isLoading = false }
        
        let instructions = """
        あなたは親切で知識豊富なフィットネス＆栄養コーチです。
        ユーザーの目標と現在の状況に基づき、目標達成のための食事と運動に関するアドバイスを生成してください。
        提案は具体的で、ポジティブな言葉遣いを心がけてください。
        """
        
        let session = LanguageModelSession(instructions: instructions)
        
        let prompt = """
        以下のユーザー状況を分析し、アドバイスを生成してください。

        # ユーザーの目標
        - 1日の目標炭水化物: \(basicNutritionGoal.carbohydrates) g
        - 1日の目標タンパク質: \(basicNutritionGoal.protein) g
        - 1日の目標脂質: \(basicNutritionGoal.fatTotal) g
        
        # 現在の状況
        - 現在の炭水化物: \(currentNutrition.carbohydrates) g
        - 現在のタンパク質: \(currentNutrition.protein) g
        - 現在の脂質: \(currentNutrition.fatTotal) g
        """
        
        do {
            // Use '.respond(to:generating:)' method for LanguageModelSession.
            let generatedAdvice = try await session.respond(to: prompt, generating: DailyAdvice.self).content
            self.advice = generatedAdvice
        } catch {
            print("Can't generate advice: \(error)")
        }
    }
}

