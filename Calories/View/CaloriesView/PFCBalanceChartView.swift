//
//  PFCBalanceChartView.swift
//  Calories
//
//  Created by Gemini on 2025/11/06.
//

import SwiftUI
import Charts

struct PFCData: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let color: Color
}

struct PFCBalanceChartView: View {
    var basicNutrition: BasicNutrition
    
    private var pfcData: [PFCData] {
        let proteinCalories = Double(basicNutrition.protein * 4)
        let fatCalories = Double(basicNutrition.fatTotal * 9)
        let carbohydratesCalories = Double(basicNutrition.carbohydrates * 4)
        
        let totalCalories = proteinCalories + fatCalories + carbohydratesCalories
        
        if totalCalories == 0 {
            return []
        }
        
        return [
            PFCData(name: "Protein", value: proteinCalories, color: .proteinPink),
            PFCData(name: "Fat", value: fatCalories, color: .fatSkyBlue),
            PFCData(name: "Carbohydrates", value: carbohydratesCalories, color: .carbohydratesBlue)
        ]
    }
    
    var body: some View {
        VStack {
            Chart(pfcData) { data in
                SectorMark(
                    angle: .value("Calories", data.value),
                    innerRadius: .ratio(0.6),
                    angularInset: 2.0
                )
                .foregroundStyle(data.color)
                .cornerRadius(8)
            }
        }
    }
}

struct PFCBalanceTopView: View {
    var basicNutrition: BasicNutrition
    
    private var pfcData: [PFCData] {
        let proteinCalories = Double(basicNutrition.protein * 4)
        let fatCalories = Double(basicNutrition.fatTotal * 9)
        let carbohydratesCalories = Double(basicNutrition.carbohydrates * 4)
        
        let totalCalories = proteinCalories + fatCalories + carbohydratesCalories
        
        if totalCalories == 0 {
            return []
        }
        
        return [
            PFCData(name: "Protein", value: proteinCalories, color: .proteinPink),
            PFCData(name: "Fat", value: fatCalories, color: .fatSkyBlue),
            PFCData(name: "Carbohydrates", value: carbohydratesCalories, color: .carbohydratesBlue)
        ]
    }
    
    var body: some View {
        HStack(spacing: 25) {
            if pfcData.isEmpty {
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundStyle(.gray.opacity(0.3))
                    .frame(width: 36, height: 36)
                HStack(spacing: 10) {
                    HealthValueView(name: "Protein", value: 0, unit: "%", color: .proteinPink)
                    Divider()
                    HealthValueView(name: "Fat", value: 0, unit: "%", color: .fatSkyBlue)
                    Divider()
                    HealthValueView(name: "Carbohydrates", value: 0, unit: "%", color: .carbohydratesBlue)
                }
                .padding(.vertical, 15)
            } else {
                Chart(pfcData) { data in
                    SectorMark(
                        angle: .value("Calories", data.value),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.0
                    )
                    .foregroundStyle(data.color)
                    .cornerRadius(4)
                }
                .frame(width: 45, height: 45)
                
                HStack(spacing: 10) {
                    ForEach(Array(pfcData.enumerated()), id: \.element.id) { index, data in
                        let totalCalories = pfcData.reduce(0) { $0 + $1.value }
                        let percentage = totalCalories > 0 ? (data.value / totalCalories) * 100 : 0
                        
                        HealthValueView(name: data.name, value: Int(percentage), unit: "%", color: data.color)
                        
                        if index < pfcData.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.vertical, 15)
            }
        }
    }
}

struct PFCBalanceChartView_Previews: PreviewProvider {
    static var previews: some View {
        PFCBalanceTopView(basicNutrition: BasicNutrition(protein: 60, carbohydrates: 250, fatTotal: 60))
        PFCBalanceTopView(basicNutrition: BasicNutrition(protein: 0, carbohydrates: 0, fatTotal: 0))
    }
}
