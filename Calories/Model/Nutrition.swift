//
//  Nutrition.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/11.
//

import Foundation
import SwiftUI

// MARK: - For UserDafualts
let PROTEIN_GOAL_KEY_NAME = "protein_goal"
let CARBOHYDRATES_GOAL_KEY_NAME = "carbohydrates_goal"
let FAT_TOTAL_GOAL_KEY_NAME = "fat_total_goal"

let PROTEIN_GOAL_DEFAULT = 60
let CARBOHYDRATES_GOAL_DEFAULT = 250
let FAT_TOTAL_GOAL_DEFAULT = 60


// MARK: - Basic Nutrition
struct BasicNutrition {
    /// Protein
    let protein: Int
    /// Carbohydrates
    let carbohydrates: Int
    /// Total Fat
    let fatTotal: Int
    
    /// Nutrition goal
//    static func goal() -> BasicNutrition {
//        let protein = UserDefaults.standard.integer(forKey: PROTEIN_GOAL_KEY_NAME)
//        let carbohydrates = UserDefaults.standard.integer(forKey: CARBOHYDRATES_GOAL_KEY_NAME)
//        let fatTotal = UserDefaults.standard.integer(forKey: FAT_TOTAL_GOAL_KEY_NAME)
//
//        print("🫐 \(protein), \(carbohydrates), \(fatTotal)")
//
//        return BasicNutrition(protein: protein != 0 ? protein : PROTEIN_GOAL_DEFAULT,
//                              carbohydrates: carbohydrates != 0 ? carbohydrates : CARBOHYDRATES_GOAL_DEFAULT,
//                              fatTotal: fatTotal != 0 ? fatTotal : FAT_TOTAL_GOAL_DEFAULT)
//    }
}

// MARK: - Basic nutrition goal
class BasicNutritionGoal: ObservableObject {
    @AppStorage(PROTEIN_GOAL_KEY_NAME) var protein = PROTEIN_GOAL_DEFAULT
    @AppStorage(CARBOHYDRATES_GOAL_KEY_NAME) var carbohydrates = CARBOHYDRATES_GOAL_DEFAULT
    @AppStorage(FAT_TOTAL_GOAL_KEY_NAME) var fatTotal = FAT_TOTAL_GOAL_DEFAULT
}
