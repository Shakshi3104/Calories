//
//  ContentView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: CaloriesViewModel
    @StateObject var basicNutritionGoal: BasicNutritionGoal
    
    var body: some View {
        VStack {
            CaloriesView(viewModel: viewModel,
                         basicNutritionGoal: basicNutritionGoal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: CaloriesViewModel(),
                    basicNutritionGoal: BasicNutritionGoal())
    }
}
