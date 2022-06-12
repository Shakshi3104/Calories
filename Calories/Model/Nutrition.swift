//
//  Nutrition.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/11.
//

import Foundation

// MARK: - For UserDafualts
let PROTEIN_GOAL_KEY_NAME = "protein_goal"
let CARBOHYDRATES_GOAL_KEY_NAME = "carbohydrates_goal"
let FAT_TOTAL_GOAL_KEY_NAME = "fat_total_goal"

let PROTEIN_GOAL_DEFAULT = 60.0
let CARBOHYDRATES_GOAL_DEFAULT = 250.0
let FAT_TOTAL_GOAL_DEFAULT = 60.0


// MARK: - Basic Nutrition
struct BasicNutrition {
    /// Protein
    let protein: Double
    /// Carbohydrates
    let carbohydrates: Double
    /// Total Fat
    let fatTotal: Double
    
    /// Nutrition goal
    static func goal() -> BasicNutrition {
        let protein = UserDefaults.standard.double(forKey: PROTEIN_GOAL_KEY_NAME)
        let carbohydrates = UserDefaults.standard.double(forKey: CARBOHYDRATES_GOAL_KEY_NAME)
        let fatTotal = UserDefaults.standard.double(forKey: FAT_TOTAL_GOAL_KEY_NAME)
        
        return BasicNutrition(protein: protein != 0.0 ? protein : PROTEIN_GOAL_DEFAULT,
                              carbohydrates: carbohydrates != 0.0 ? carbohydrates : CARBOHYDRATES_GOAL_DEFAULT,
                              fatTotal: fatTotal != 0.0 ? fatTotal : FAT_TOTAL_GOAL_DEFAULT)
    }
}
