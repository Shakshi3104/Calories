//
//  CaloriesWidgetView.swift
//  CaloriesWidgetExtension
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI
import WidgetKit

// MARK: - Medium Widget
struct CaloriesWidgetMediumView: View {
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        HStack {
            CalorieNutritionRingView(energy: energy, basicNutrition: basicNutrition,
            basicNutritionGoal: basicNutritionGoal)
            .scaleEffect(0.8)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    EnergySmallView(value: energy.ingestible, color: .irisPurple, unit: "KCAL")
                    EnergySmallView(value: basicNutrition.protein, color: .proteinOrange, unit: "g")
                    EnergySmallView(value: basicNutrition.carbohydrates, color: .carbohydratesBlue, unit: "g")
                    EnergySmallView(value: basicNutrition.fatTotal, color: .fatPurple, unit: "g")
                }
            }
            .padding(.leading, 20)
        }
    }
}

// MARK: - Small Widget
struct CaloriesWidgetSmallView: View {
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        CalorieNutritionRingView(energy: energy, basicNutrition: basicNutrition, basicNutritionGoal: basicNutritionGoal)
            .scaleEffect(0.8)
    }
}

// MARK: - Small Widget (Bar chart)
struct BarView: View {
    var value: CGFloat
    var color: Color = Color(.sRGB, red: 0.2, green: 0.5, blue: 0.8)
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: value, height: 15)
                .foregroundColor(color)
        }
    }
}

struct EnergyBarChartView: View {
    var energy: Energy
    
    let scale: CGFloat = 1.0 / 20.0
    let maxWidth = 90.0
    
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if redactionReasons.contains(.privacy) {
                    // hide bar charts
                    BarView(value: maxWidth, color: .consumptionEnergyOrange.opacity(0.2))
                    BarView(value: maxWidth, color: .intakeEnergyGreen.opacity(0.2))
                } else {
                    let values = calcBarChartWidth(
                        consumptionEnergy: energy.resting + energy.active,
                        intakeEnergy: energy.dietary
                    )
                    
                    BarView(value: values.comsumption,
                            color: .consumptionEnergyOrange)
                    
                    BarView(value: values.intake,
                            color: .intakeEnergyGreen)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 5)
    }
    
    private func calcBarChartWidth(consumptionEnergy: Int, intakeEnergy: Int) -> (comsumption: CGFloat, intake: CGFloat) {
        
        if CGFloat(consumptionEnergy) * scale < maxWidth &&
            CGFloat(intakeEnergy) * scale < maxWidth {
            return (CGFloat(consumptionEnergy) * scale, CGFloat(intakeEnergy) * scale)
        }
        
        if consumptionEnergy > intakeEnergy {
            return (maxWidth, CGFloat(intakeEnergy) / CGFloat(consumptionEnergy) * maxWidth)
        } else {
            return (CGFloat(consumptionEnergy) / CGFloat(intakeEnergy) * maxWidth, maxWidth)
        }
    }
}

struct EnergySmallView: View {
    var value: Int
    var color: Color
    var unit: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 1) {
            Text("\(value)")
                .foregroundColor(color)
                .font(.system(.title3, design: .rounded).monospacedDigit())
                .fontWeight(.medium)
                .privacySensitive()
            Text(unit)
                .foregroundColor(color)
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .padding(.bottom, 1)
                
        }
    }
}

struct CaloriesWidgetSmallBarChartView: View {
    var energy: Energy
    
    var body: some View {
        VStack {
            EnergyBarChartView(energy: energy)
            
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    EnergySmallView(value: energy.resting + energy.active, color: .consumptionEnergyOrange, unit: "KCAL")
                    EnergySmallView(value: energy.dietary, color: .intakeEnergyGreen, unit: "KCAL")
                    EnergySmallView(value: energy.ingestible, color: .irisPurple, unit: "KCAL")
                }
                Spacer()
            }
            .padding(.leading, 20)
        }
    }
}

// MARK: - Calorie and Nutrition Ring View
struct CalorieNutritionRingView: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        ZStack {
            if redactionReasons.contains(.privacy) {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.intakeEnergyGreen)
                    .frame(width: 120, height: 120)
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.proteinOrange)
                    .frame(width: 89.5, height: 89.5)
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.carbohydratesBlue)
                    .frame(width: 58.5, height: 58.5)
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.fatPurple)
                    .frame(width: 28, height: 28)
            } else {
                // Calorie Ring
                let calorie = Float(energy.dietary) / Float(energy.active + energy.resting)
                RingView(value: calorie,
                         startColor: .intakeEnergyLightGreen,
                         endColor: .intakeEnergyGreen,
                         lineWidth: 15,
                         size: 120)
                
                // Protein Ring
                let protein = Float(basicNutritionGoal.protein)
                RingView(value: protein, startColor: .proteinLightOrange, endColor: .proteinOrange,
                lineWidth: 15,
                         size: 89.5)
                
                // Carbohydrates Ring
                let carbohydrates = Float(basicNutrition.carbohydrates) / Float(basicNutritionGoal.carbohydrates)
                RingView(value: carbohydrates, startColor: .carbohydratesLightBlue, endColor: .carbohydratesBlue,
                lineWidth: 15,
                         size: 58.5)
                
                // Fat Ring
                let fat = Float(basicNutrition.fatTotal) / Float(basicNutritionGoal.fatTotal)
                RingView(value: fat, startColor: .fatLightPurple, endColor: .fatPurple,
                lineWidth: 15,
                size: 28)
            }
        }
    }
}

// MARK: - Previews
struct CaloriesWidgetView_Previews: PreviewProvider {
    static var energy = Energy(resting: 1500, active: 200, dietary: 4000)
    static var basicNutrition = BasicNutrition(protein: 50, carbohydrates: 200, fatTotal: 30)
    
    static var previews: some View {
        Group {
            CaloriesWidgetMediumView(energy: energy, basicNutrition: basicNutrition)
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            CaloriesWidgetSmallView(energy: energy, basicNutrition: basicNutrition)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            CaloriesWidgetSmallBarChartView(energy: energy)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
