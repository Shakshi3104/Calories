//
//  ContentView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var healthModel: HealthModel
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    var body: some View {
        VStack {
            CaloriesView(energy: healthModel.energy,
                         basicNutrition: healthModel.basicNutrition,
            basicNutritionGoal: basicNutritionGoal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(healthModel: HealthModel(),
                    basicNutritionGoal: BasicNutritionGoal())
    }
}
