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
    @StateObject var energyModel = EnergyModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(energyModel: energyModel)
        }
        .onChange(of: scenePhase) { scene in
            switch scene {
            case .active:
                print("📲 active")
                energyModel.updateEnergy()
                WidgetCenter.shared.reloadTimelines(ofKind: "Calories")
            case .inactive:
                print("📲 inactive")
            case .background:
                print("📲 background")
            @unknown default: break
            }
        }
    }
}
