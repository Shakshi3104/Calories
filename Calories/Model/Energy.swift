//
//  Energy.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

struct Energy {
    /// resting energy - energy your body uses each day while minimally active.
    let resting: Int
    /// active energy - energy burned over
    let active: Int
    /// dietary energy - energy in food.
    let dietary: Int
    /// ingestible energy - the value calculated by adding resting energy and active energy and subtracting dietary energy
    let ingestible: Int
    
    init(resting: Int, active: Int, dietary: Int) {
        self.resting = resting
        self.active = active
        self.dietary = dietary
        self.ingestible = resting + active - dietary
    }
}
