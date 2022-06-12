//
//  CaloriesEntry.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import WidgetKit


struct CaloriesEntry: TimelineEntry {
    var date: Date = Date()
    let energy: Energy
    let basicNutrition: BasicNutrition
    
    init(_ energy: Energy, _ basicNutrition: BasicNutrition) {
        self.energy = energy
        self.basicNutrition = basicNutrition
    }
    
    init(resting: Int, active: Int, dietary: Int, protein: Int, carbohydrates: Int, fat: Int) {
        self.init(Energy(resting: resting, active: active, dietary: dietary),
        BasicNutrition(protein: protein, carbohydrates: carbohydrates, fatTotal: fat))
    }
}

struct CaloriesTimeline: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (CaloriesEntry) -> Void) {
        let entry = CaloriesEntry(resting: 1620, active: 130, dietary: 1850,
                                  protein: 60, carbohydrates: 200, fat: 30)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CaloriesEntry>) -> Void) {
        let refresh = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        
        HealthObserver().getEnergyWithRequestStatus { (resting, active, dietary) in
            HealthObserver().getBasicNutritionWithRequestStatus { (protein, carbohydrates, fat) in
                let entry = CaloriesEntry(resting: resting, active: active, dietary: dietary,
                                          protein: protein, carbohydrates: carbohydrates, fat: fat)
                
                let timeline = Timeline(entries: [entry], policy: .after(refresh))
                completion(timeline)
            }
        }
    }
    
    func placeholder(in context: Context) -> CaloriesEntry {
        CaloriesEntry(resting: 1620, active: 370, dietary: 2150,
                        protein: 60, carbohydrates: 200, fat: 30)
    }
}
