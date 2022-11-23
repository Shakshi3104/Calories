//
//  CaloriesWidgetLockScreenView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/11/23.
//

import SwiftUI
import WidgetKit

// MARK: - Calorie for accessoryCircular
@available(iOSApplicationExtension 16.0, *)
struct CalorieLockScreenCircularView: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var energy: Energy
    
    var body: some View {
        if redactionReasons.contains(.privacy) {
            Gauge(value: 0.0) {
                Image(systemName: "takeoutbag.and.cup.and.straw")
            }
            .gaugeStyle(.accessoryCircular)
        } else {
            Gauge(value: Float(energy.dietary), in: 0...Float((energy.resting + energy.active))) {
                Image(systemName: "takeoutbag.and.cup.and.straw")
            } currentValueLabel: {
                Text("\(energy.dietary)")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                let activeCal = Double(energy.resting + energy.active) / 1000.0
                Text(String(format: "%.1f", activeCal) + "k")
            }
            .gaugeStyle(.accessoryCircular)
        }
    }
}

// MARK: Basic Nutrition for accesoryCircular
@available(iOSApplicationExtension 16.0, *)
struct BasicNutritionLockScreenCircularView: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var value: Int
    var goal: Int
    var systemName: String
    
    var body: some View {
        if redactionReasons.contains(.privacy) {
            Gauge(value: 0.0) {
                Image(systemName: systemName)
            }
            .gaugeStyle(.accessoryCircular)
        } else {
            Gauge(value: Float(value), in: 0...Float(goal)) {
                Image(systemName: systemName)
            } currentValueLabel: {
                Text("\(value)")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("\(goal)")
            }
            .gaugeStyle(.accessoryCircular)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct ProteinLockScreenCircularView: View {
    var basicNutrition: BasicNutrition
    
    // Basic nutrition goal
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        BasicNutritionLockScreenCircularView(value: basicNutrition.protein, goal: basicNutritionGoal.protein, systemName: "circlebadge.2")
    }
}

@available(iOSApplicationExtension 16.0, *)
struct CarbohydratesLockScreenCircularView: View {
    var basicNutrition: BasicNutrition
    
    // Basic nutrition goal
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        BasicNutritionLockScreenCircularView(value: basicNutrition.carbohydrates, goal: basicNutritionGoal.carbohydrates, systemName: "speedometer")
    }
}

@available(iOSApplicationExtension 16.0, *)
struct FatLockScreenCircularView: View {
    var basicNutrition: BasicNutrition
    
    // Basic nutrition goal
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        BasicNutritionLockScreenCircularView(value: basicNutrition.fatTotal, goal: basicNutritionGoal.fatTotal, systemName: "scalemass")
    }
}

// MARK: - Calorie and Basic Nutrition for accessoryCircular
struct CalorieBasicNutritionLockScreenCircularView: View {
    
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var body: some View {
        CaloriesWidgetSmallView(energy: energy, basicNutrition: basicNutrition)
            .scaleEffect(0.55)
    }
}

// MARK: - Basic Nutrition for accessoryRectangular
@available(iOS 16.0, *)
struct BasicNutritionLockScreenRectangleView: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var basicNutrition: BasicNutrition
    
    // Basic nutrition goal
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "circlebadge.2")
                    .font(.body)
                if redactionReasons.contains(.privacy) {
                    Text("--/-- g")
                } else {
                    Text("\(basicNutrition.protein)/\(basicNutritionGoal.protein) g")
                }
            }
            
            HStack {
                Image(systemName: "speedometer")
                    .font(.body)
                if redactionReasons.contains(.privacy) {
                    Text("--/-- g")
                } else {
                    Text("\(basicNutrition.carbohydrates)/\(basicNutritionGoal.carbohydrates) g")
                }
            }
            
            HStack {
                Image(systemName: "scalemass")
                    .font(.body)
                if redactionReasons.contains(.privacy) {
                    Text("--/-- g")
                } else {
                    Text("\(basicNutrition.fatTotal)/\(basicNutritionGoal.fatTotal) g")
                }
            }
        }
    }
}


struct CaloriesWidgetLockScreenView_Previews: PreviewProvider {
    static var energy = Energy(resting: 1500, active: 200, dietary: 4000)
    static var basicNutrition = BasicNutrition(protein: 50, carbohydrates: 200, fatTotal: 30)
    
    static var previews: some View {
        if #available(iOS 16.0, *) {
            Group {
                BasicNutritionLockScreenRectangleView(basicNutrition: basicNutrition)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                
                CalorieBasicNutritionLockScreenCircularView(energy: energy, basicNutrition: basicNutrition)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                
                CalorieLockScreenCircularView(energy: energy)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                
                ProteinLockScreenCircularView(basicNutrition: basicNutrition)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                
                CarbohydratesLockScreenCircularView(basicNutrition: basicNutrition)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                
                FatLockScreenCircularView(basicNutrition: basicNutrition)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                
            }
        } else {
            // Fallback on earlier versions
            Text("Not preview")
        }
    }
}