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
// MARK: - Calorie
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
        .description("See your ingestible energy.")
        .supportedFamilies([.accessoryCircular])
    }
}

// MARK: - Protein
@available(iOSApplicationExtension 16.0, *)
struct ProteinLockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            ProteinLockScreenCircularView(basicNutrition: entry.basicNutrition)
        default:
            ProteinLockScreenCircularView(basicNutrition: entry.basicNutrition)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct ProteinLockScreenWidget: Widget {
    let kind: String = "Protein Single"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            ProteinLockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calorie")
        .description("See your intake protein.")
        .supportedFamilies([.accessoryCircular])
    }
}

// MARK: - Carbohydrates
@available(iOSApplicationExtension 16.0, *)
struct CarbohydratesLockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CarbohydratesLockScreenCircularView(basicNutrition: entry.basicNutrition)
        default:
            CarbohydratesLockScreenCircularView(basicNutrition: entry.basicNutrition)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct CarbohydratesLockScreenWidget: Widget {
    let kind: String = "Carbohydrates Single"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            CarbohydratesLockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calorie")
        .description("See your intake carbohydrates.")
        .supportedFamilies([.accessoryCircular])
    }
}

// MARK: - Fat
@available(iOSApplicationExtension 16.0, *)
struct FatLockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            FatLockScreenCircularView(basicNutrition: entry.basicNutrition)
        default:
            FatLockScreenCircularView(basicNutrition: entry.basicNutrition)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct FatLockScreenWidget: Widget {
    let kind: String = "Fat Single"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            FatLockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calorie")
        .description("See your intake fat.")
        .supportedFamilies([.accessoryCircular])
    }
}


// MARK: -
@main
struct CaloriesWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CalorieNutritionWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            CalorieLockScreenWidget()
            ProteinLockScreenWidget()
            CarbohydratesLockScreenWidget()
            FatLockScreenWidget()
        }
    }
}
