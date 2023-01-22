//
//  ViewModel.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2023/01/22.
//

import Foundation

// MARK: - CaloriesViewModel
final class CaloriesViewModel: ObservableObject {
    // Published
    /// Energy
    @Published var energy: Energy = Energy(resting: 0, active: 0, dietary: 0)
    /// Basic Nutrition
    @Published var basicNutrition: BasicNutrition = BasicNutrition(protein: 0, carbohydrates: 0, fatTotal: 0)
    
    /// date selection
    @Published var dateSelection = Date()
    
    /// Health Observer
    let healthObserver = HealthObserver()
    
    func updateEnergy() {
        healthObserver.getEnergyWithRequestingAuthorization(date: dateSelection) { (resting, active, dietary) -> Void in
            print("🍎 \(resting), \(active), \(dietary)")
            
            DispatchQueue.main.async {
                self.energy = Energy(resting: resting, active: active, dietary: dietary)
            }
        }
    }
    
    func updateBasicNutrition() {
        healthObserver.getBasicNutritionWithRequestingAuthorization(date: dateSelection) { (protein, carbohydrates, fatTotal) in
            print("🍇 \(protein), \(carbohydrates), \(fatTotal)")
            
            DispatchQueue.main.async {
                self.basicNutrition = BasicNutrition(protein: protein, carbohydrates: carbohydrates, fatTotal: fatTotal)
            }
        }
    }
}

// MARK: - CaloriesViewModel extension: async
extension CaloriesViewModel {
    func updateEnergy() async {
        let resting = await healthObserver.getRestingEnergy(date: dateSelection)
        let active = await healthObserver.getActiveEnergy(date: dateSelection)
        let dietary = await healthObserver.getDietaryEnergy(date: dateSelection)
        
        print("🍎🍎 \(resting), \(active), \(dietary)")
        
        DispatchQueue.main.async {
            self.energy = Energy(resting: resting, active: active, dietary: dietary)
        }
    }
    
    func updateBasicNutrition() async {
        let protein = await healthObserver.getProtein(date: dateSelection)
        let carbohydrates = await healthObserver.getCabohydrates(date: dateSelection)
        let fatTotal = await healthObserver.getFatTotal(date: dateSelection)
        
        print("🍇🍇 \(protein), \(carbohydrates), \(fatTotal)")
        
        DispatchQueue.main.async {
            self.basicNutrition = BasicNutrition(protein: protein, carbohydrates: carbohydrates, fatTotal: fatTotal)
        }
    }
}
