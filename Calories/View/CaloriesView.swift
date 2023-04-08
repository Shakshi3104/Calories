//
//  CaloriesDetailView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/12.
//

import SwiftUI

// MARK: - CaloriesView
struct CaloriesView: View {
    
    @StateObject var viewModel: CaloriesViewModel
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    @State private var isPresented = false
    @State private var isToday = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Calorie") {
                    NavigationLink {
                        CalorieDetailView(energy: viewModel.energy)
                    } label: {
                        CalorieTopView(energy: viewModel.energy)
                    }
                }
                
                Section("Nutrition") {
                    NavigationLink {
                        NutritionDetailView(basicNutrition: viewModel.basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    } label: {
                        NutritionTopView(basicNutrition: viewModel.basicNutrition, basicNutritionGoal: basicNutritionGoal)
                    }
                }
            }
            // display selected day
            .navigationTitle(viewModel.dateSelection.formatted(
                Date.FormatStyle().month(.twoDigits).day(.twoDigits).weekday()
            ))
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // date add
                        viewModel.dateSelection = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.dateSelection)!
                        
                        // update energy, basic nutrition, and isToday
                        updateEnergyBasicNutritionIsToday()
                    } label: {
                        Image(systemName: "arrowtriangle.backward.fill")
                    }
                }
                
                // date selection
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // date add
                        viewModel.dateSelection = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.dateSelection)!
                        
                        // update energy, basic nutrition, and isToday
                        updateEnergyBasicNutritionIsToday()
                    } label: {
                        Image(systemName: "arrowtriangle.forward.fill")
                    }
                    .disabled(isToday)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPresented, onDismiss: {
                // update energy, basic nutrition, and isToday
                updateEnergyBasicNutritionIsToday()
            }, content: {
                DateSelectionView(dateSelection: $viewModel.dateSelection)
            })
            .onAppear {
                isToday = Calendar.current.isDateInToday(viewModel.dateSelection)
            }
        }
    }
}

// MARK: -
extension CaloriesView {
    func updateEnergyBasicNutritionIsToday() {
        // update
        viewModel.updateEnergy()
        viewModel.updateBasicNutrition()
        
        // is today
        isToday = Calendar.current.isDateInToday(viewModel.dateSelection)
    }
}

// MARK: - Calorie top View
struct CalorieTopView: View {
    var energy: Energy
    
    private let textStyle: Font.TextStyle = .body
    
    var body: some View {
        HStack(spacing: 25) {
            let value = energy.dietary > 0 ? Float(energy.dietary) / Float(energy.active + energy.resting) : 0.0
            RingView(value: value,
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
        let startDate = DateComponents(year: 2007, month: 6, day: 29)
        let endDate = Date()
        return Calendar.current.date(from: startDate)!...endDate
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
        CaloriesView(viewModel: CaloriesViewModel(),
                     basicNutritionGoal: BasicNutritionGoal())
    }
}
