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
    @StateObject var viewModel = CaloriesViewModel()
    @StateObject var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel,
                        basicNutritionGoal: basicNutritionGoal)
        }
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .active:
                print("📲 active")
                viewModel.updateEnergy()
                viewModel.updateBasicNutrition()
                
                UserDefaults(suiteName: "group.com.shakshi.Calories.goal")?.synchronize()
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
