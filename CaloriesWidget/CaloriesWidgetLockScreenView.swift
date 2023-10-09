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
            .containerBackground(for: .widget) {
                Color.clear
            }
        } else {
            Gauge(value: Float(energy.dietary), in: 0...Float((energy.resting + energy.active))) {
                Image(systemName: "takeoutbag.and.cup.and.straw")
            } currentValueLabel: {
                Text("\(energy.ingestible)")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                let activeCal = energy.resting + energy.active
                let label = activeCal < 1000 ? "\(activeCal)" : String(format: "%.1f", Double(activeCal) / 1000.0) + "k"
                Text(label)
            }
            .gaugeStyle(.accessoryCircular)
            .containerBackground(for: .widget) {
                Color.clear
            }
        }
    }
}

// MARK: - Basic Nutrition for accesoryCircular
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
            .containerBackground(for: .widget) {
                Color.clear
            }
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
            .containerBackground(for: .widget) {
                Color.clear
            }
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
struct CalorieNutritionRingViewForLockScreen: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    // Basic nutrition goal
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        ZStack {
            if redactionReasons.contains(.privacy) {
                Circle()
                    .stroke(lineWidth: 5)
                    .opacity(0.3)
                    .foregroundColor(.intakeEnergyGreen)
                    .frame(width: 51, height: 51)
                Circle()
                    .stroke(lineWidth: 5)
                    .opacity(0.3)
                    .foregroundColor(.proteinPink)
                    .frame(width: 39, height: 39)
                Circle()
                    .stroke(lineWidth: 5)
                    .opacity(0.3)
                    .foregroundColor(.carbohydratesBlue)
                    .frame(width: 27, height: 27)
                Circle()
                    .stroke(lineWidth: 5)
                    .opacity(0.3)
                    .foregroundColor(.fatSkyBlue)
                    .frame(width: 15, height: 15)
            } else {
                // Calorie Ring
                let calorie = Float(energy.dietary) / Float(energy.active + energy.resting)
                RingView(value: calorie,
                         startColor: .intakeEnergyGreen,
                         endColor: .intakeEnergyLightGreen,
                         lineWidth: 5,
                         size: 51)
                
                // Protein Ring
                let protein = Float(basicNutrition.protein) / Float(basicNutritionGoal.protein)
                RingView(value: protein, startColor: .proteinPink, endColor: .proteinLightPink,
                         lineWidth: 5,
                         size: 39)
                
                // Carbohydrates Ring
                let carbohydrates = Float(basicNutrition.carbohydrates) / Float(basicNutritionGoal.carbohydrates)
                RingView(value: carbohydrates, startColor: .carbohydratesBlue, endColor: .carbohydratesLightBlue,
                         lineWidth: 5,
                         size: 27)
                
                // Fat Ring
                let fat = Float(basicNutrition.fatTotal) / Float(basicNutritionGoal.fatTotal)
                RingView(value: fat, startColor: .fatSkyBlue, endColor: .fatLightSkyBlue,
                         lineWidth: 5,
                         size: 15)
            }
        }
    }
}


struct CalorieBasicNutritionLockScreenCircularView: View {
    
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var body: some View {
        CalorieNutritionRingViewForLockScreen(energy: energy, basicNutrition: basicNutrition)
            .containerBackground(for: .widget) {
                Color.clear
            }
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
        HStack {
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
            Spacer()
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// MARK: - Calorie for accesoryRectangular
struct CalorieLockScreenRectangleView: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var energy: Energy
    
    var body: some View {
       
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.body)
                Text("Meal")
                    .fontWeight(.bold)
                Spacer()
                    .frame(maxWidth: 16)
                if redactionReasons.contains(.privacy) {
                    Text("--")
                } else {
                    Text("\(energy.dietary)")
                        
                }
            }
            
            HStack {
                Image(systemName: "popcorn")
                    .font(.body)
                Text("Rest")
                    .fontWeight(.bold)
                Spacer()
                    .frame(maxWidth: 16)
                if redactionReasons.contains(.privacy) {
                    Text("--")
                } else {
                    Text("\(energy.ingestible)")
                }
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// MARK: -
struct CaloriesWidgetLockScreenView_Previews: PreviewProvider {
    static var energy = Energy(resting: 1500, active: 200, dietary: 4000)
    static var basicNutrition = BasicNutrition(protein: 50, carbohydrates: 200, fatTotal: 30)
    
    static var previews: some View {
        if #available(iOS 16.0, *) {
            Group {
                CalorieLockScreenRectangleView(energy: energy)
                    .preferredColorScheme(.dark)
                    .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                
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
