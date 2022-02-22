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
    
    init(_ energy: Energy) {
        self.energy = energy
    }
    
    init(resting: Int, active: Int, dietary: Int) {
        self.init(Energy(resting: resting, active: active, dietary: dietary))
    }
}

struct CaloriesTimeline: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (CaloriesEntry) -> Void) {
        let entry = CaloriesEntry(resting: 0, active: 0, dietary: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CaloriesEntry>) -> Void) {
        let refresh = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        
        EnergyObserver().getEnergyWithRequestStatus { (resting, active, dietary) in
            let entry = CaloriesEntry(resting: resting, active: active, dietary: dietary)
            
            let timeline = Timeline(entries: [entry], policy: .after(refresh))
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> CaloriesEntry {
        CaloriesEntry(resting: 1620, active: 370, dietary: 2150)
    }
}
