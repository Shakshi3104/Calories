//
//  CaloriesDetailView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/12.
//

import SwiftUI

// MARK: - CaloriesView
struct CaloriesView: View {
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Calorie") {
                    NavigationLink {
                        CalorieDetailView(energy: energy)
                    } label: {
                        CalorieTopView(energy: energy)
                    }
                }
                
                Section("Nutrition") {
                    NavigationLink {
                        NutritionDetailView(basicNutrition: basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    } label: {
                        NutritionTopView(basicNutrition: basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    }
                }
            }
            .navigationTitle("Calories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                GoalSettingView(basicNutritionGoal: basicNutritionGoal)
            }
        }
    }
}

// MARK: - Calorie top View
struct CalorieTopView: View {
    var energy: Energy
    
    private let textStyle: Font.TextStyle = .body
    
    var body: some View {
        HStack(spacing: 25) {
            RingView(value: Float(energy.dietary) / Float(energy.active + energy.resting),
                     startColor: .intakeEnergyGreen,
                     endColor: .intakeEnergyLightGreen,
                     lineWidth: 20)
            .scaleEffect(0.3)
            .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 15) {
                    CalorieView(energyName: "Resting",
                                energy: energy.resting,
                                color: .consumptionEnergyOrange,
                                textStyle: textStyle)
                    
                    Divider()
                    
                    CalorieView(energyName: "Active",
                                energy: energy.active,
                                color: .consumptionEnergyOrange,
                                textStyle: textStyle)
                }
                .padding(.horizontal, 0)
                
                HStack(spacing: 15) {
                    CalorieView(energyName: "Dietary",
                                energy: energy.dietary,
                                color: .intakeEnergyGreen,
                                textStyle: textStyle)
                    
                    Divider()
                    
                    CalorieView(energyName: "Ingestible",
                                energy: energy.ingestible,
                                color: .irisPurple,
                                textStyle: .body)
                }
                .padding(.horizontal, 0)
        }
        .padding(.vertical, 15)
    }
    }
}

// MARK: - Nutrition top View
struct NutritionTopView: View {
    var basicNutrition: BasicNutrition
    
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    private let textStyle: Font.TextStyle = .body
    
    var body: some View {
        HStack(spacing: 25) {
            ZStack {
                RingView(value: Float(basicNutrition.protein) / Float(basicNutritionGoal.protein),
                         startColor: .proteinPink,
                         endColor: .proteinLightPink,
                         lineWidth: 20)
                .scaleEffect(0.3)
                
                RingView(value: Float(basicNutrition.carbohydrates) / Float(basicNutritionGoal.carbohydrates),
                         startColor: .carbohydratesBlue,
                         endColor: .carbohydratesLightBlue,
                         lineWidth: 30)
                .scaleEffect(0.2)
                
                RingView(value: Float(basicNutrition.fatTotal) / Float(basicNutritionGoal.fatTotal),
                         startColor: .fatSkyBlue,
                         endColor: .fatLightSkyBlue,
                         lineWidth: 50)
                .scaleEffect(0.107)
            }
            .frame(width: 45, height: 45)
            
            HStack(spacing: 10) {
                HealthValueView(name: "Protein", value: basicNutrition.protein, unit: "g", color: .proteinPink)
                
                Divider()
                
                HealthValueView(name: "Carbohydrates", value: basicNutrition.carbohydrates, unit: "g", color: .carbohydratesBlue)
                
                Divider()
                
                HealthValueView(name: "Fat", value: basicNutrition.fatTotal, unit: "g", color: .fatSkyBlue)
            }
        }
        .padding(.vertical, 15)
    }
}


// MARK: - Preview
struct CaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(energy: Energy(resting: 1500,
                                          active: 200,
                                          dietary: 1600),
        basicNutrition: BasicNutrition(protein: 30, carbohydrates: 200, fatTotal: 20),
        basicNutritionGoal: BasicNutritionGoal())
        .preferredColorScheme(.dark)
        
    }
}
