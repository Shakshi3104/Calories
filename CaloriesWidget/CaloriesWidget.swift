//
//  CaloriesWidget.swift
//  CaloriesWidget
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import WidgetKit
import SwiftUI


// MARK: - Entry View
struct CaloriesWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry

    var body: some View {
        switch family {
        case .systemSmall:
            CaloriesWidgetSmallView(energy: entry.energy, basicNutrition: entry.basicNutrition)
        case .systemMedium:
            CaloriesWidgetMediumView(energy: entry.energy, basicNutrition: entry.basicNutrition)
        default:
            CaloriesWidgetMediumView(energy: entry.energy, basicNutrition: entry.basicNutrition)
        }
    }
}

struct CaloriesWidgetChartEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            CaloriesWidgetSmallBarChartView(energy: entry.energy)
        default:
            CaloriesWidgetSmallBarChartView(energy: entry.energy)
        }
    }
}

// MARK: - main

struct CaloriesWidget: Widget {
    let kind: String = "Calories"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            CaloriesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calories")
        .description("See your intake and consumption energy.")
        .supportedFamilies([.systemMedium, .systemSmall])
    }
}

struct CaloriesChartWidget: Widget {
    let kind: String = "CaloriesChart"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaloriesTimeline()) { entry in
            CaloriesWidgetChartEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.fitnessGray)
        }
        .configurationDisplayName("Calories")
        .description("See your intake and consumption energy.")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct CaloriesWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CaloriesWidget()
        CaloriesChartWidget()
    }
}
