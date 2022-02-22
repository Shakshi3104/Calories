//
//  CaloriesWidget.swift
//  CaloriesWidget
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import WidgetKit
import SwiftUI


struct CaloriesWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @State var entry: CaloriesEntry

    var body: some View {
        switch family {
        case .systemSmall:
            CaloriesWidgetSmallView(energy: entry.energy)
        case .systemMedium:
            CaloriesWidgetMediumView(energy: entry.energy)
        default:
            CaloriesWidgetMediumView(energy: entry.energy)
        }
    }
}

@main
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
