//
//  ContentView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var energyModel = EnergyModel()
    
    var body: some View {
        CaloriesView(energy: energyModel.energy)
            .task {
                await energyModel.updateEnergy()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
