//
//  CaloriesApp.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI
import WidgetKit

@main
struct CaloriesApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var healthModel = HealthModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(healthModel: healthModel)
        }
        .onChange(of: scenePhase) { scene in
            switch scene {
            case .active:
                print("📲 active")
                healthModel.updateEnergy()
                healthModel.updateBasicNutrition()
                WidgetCenter.shared.reloadAllTimelines()
            case .inactive:
                print("📲 inactive")
            case .background:
                print("📲 background")
            @unknown default: break
            }
        }
    }
}
