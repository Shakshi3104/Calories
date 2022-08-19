//
//  CaloriesDetailView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/12.
//

import SwiftUI

// MARK: - CaloriesView
struct CaloriesView: View {
    
    @StateObject var healthModel: HealthModel
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    @State private var isPresented = false
    @State private var dateSelection = Date()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                Section("Calorie") {
                    NavigationLink {
                        CalorieDetailView(energy: healthModel.energy)
                    } label: {
                        CalorieTopView(energy: healthModel.energy)
                    }
                }
                
                Section("Nutrition") {
                    NavigationLink {
                        NutritionDetailView(basicNutrition: healthModel.basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    } label: {
                        NutritionTopView(basicNutrition: healthModel.basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    }
                }
            }
            // display selected day
            .navigationTitle(dateFormatter.string(from: dateSelection))
            .toolbar {
                // date selection
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPresented, onDismiss: {
                healthModel.updateEnergy(date: dateSelection)
                healthModel.updateBasicNutrition(date: dateSelection)
            }, content: {
                DateSelectionView(dateSelection: $dateSelection)
            })
            .refreshable {
                await healthModel.updateEnergy(date: dateSelection)
                await healthModel.updateBasicNutrition(date: dateSelection)
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

// MARK: - Date selection View
struct DateSelectionView: View {
    @Binding var dateSelection: Date
    private let dateRange: ClosedRange<Date> = {
        // startDate is the day when the original iPhone was released.
        let startDate = DateComponents(year: 2007, month: 6, day: 29).date!
        let endDate = Date()
        return startDate...endDate
    }()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            DatePicker("",
                       selection: $dateSelection,
                       in: dateRange,
                       displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}


// MARK: - Preview
struct CaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(healthModel: HealthModel(),
        basicNutritionGoal: BasicNutritionGoal())
        .preferredColorScheme(.dark)
        
    }
}
