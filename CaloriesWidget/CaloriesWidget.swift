//
//  CaloriesWidget.swift
//  CaloriesWidget
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import WidgetKit
import SwiftUI


// MARK: - Widget and Lock screen
struct CaloriesWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry

    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
            case .systemSmall:
                CaloriesWidgetSmallView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            case .systemMedium:
                CaloriesWidgetMediumView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            case .accessoryCircular:
                CalorieBasicNutritionLockScreenCircularView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            case .accessoryRectangular:
                BasicNutritionLockScreenRectangleView(basicNutrition: entry.basicNutrition)
            default:
                CaloriesWidgetSmallView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            }
        } else {
            // Fallback on earlier versions
            switch family {
            case .systemSmall:
                CaloriesWidgetSmallView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            case .systemMedium:
                CaloriesWidgetMediumView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            default:
                CaloriesWidgetSmallView(energy: entry.energy, basicNutrition: entry.basicNutrition)
            }
        }
    }
}

struct CalorieNutritionWidget: Widget {
    let kind: String = "Calories"
    
    private var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                .accessoryCircular,
                .accessoryRectangular,
                .systemMedium,
                .systemSmall
            ]
        } else {
            // Fallback on earlier versions
            return [
                .systemMedium,
                .systemSmall
            ]
        }
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            CaloriesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calories and Nutrition")
        .description("See your intake energy and basic nutrition.")
        .supportedFamilies(supportedFamilies)
    }
}

// MARK: - Lock screen
@available(iOSApplicationExtension 16.0, *)
struct CalorieLockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CalorieLockScreenCircularView(energy: entry.energy)
        default:
            CalorieLockScreenCircularView(energy: entry.energy)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct CalorieLockScreenWidget: Widget {
    let kind: String = "Calorie Single"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            CalorieLockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calorie")
        .description("See your intake energy.")
        .supportedFamilies([.accessoryCircular])
    }
}

@main
struct CaloriesWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CalorieNutritionWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            CalorieLockScreenWidget()
        }
    }
}
