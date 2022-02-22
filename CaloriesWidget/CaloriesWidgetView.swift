//
//  CaloriesWidgetView.swift
//  CaloriesWidgetExtension
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI
import WidgetKit

// MARK: - Medium Widget
struct CalorieWidgetMediumView: View {
    var energyName: String
    var energy: Int
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(energyName)
                .foregroundColor(color)
                .font(.caption)
            HStack(alignment: .bottom, spacing: 2) {
                Text("\(energy)")
                    .font(.system(.body, design: .rounded).monospacedDigit())
                    .fontWeight(.medium)
                Text("kcal")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 1)
            }
        }
    }
}

struct CaloriesWidgetMediumView: View {
    var energy: Energy
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            
            HStack(spacing: 5) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.heathcareOrange)
                    .font(.title2)
                Text("Energy")
                    .foregroundColor(.heathcareOrange)
                    .font(.title2)
                
                Spacer().frame(width: 190)
                if energy.ingestible >= 0 {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                }
            }
                
            HStack(spacing: 5) {
                CalorieWidgetMediumView(energyName: "Resting",
                                        energy: energy.resting,
                                        color: .heathcareOrange)
                
                Divider()
                
                CalorieWidgetMediumView(energyName: "Active",
                                        energy: energy.active,
                                        color: .heathcareOrange)
                
                Divider()
                
                CalorieWidgetMediumView(energyName: "Dietary",
                                        energy: energy.dietary,
                                        color: .heathcareGreen)
                
                Divider()
                
                CalorieWidgetMediumView(energyName: "Ingestible",
                                        energy: energy.ingestible,
                                        color: .heathcareIrisPurple)
            }
            .frame(height: 50)
        }
    }
}

// MARK: - Small Widget
struct CaloriesWidgetSmallView: View {
    var energy: Energy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.heathcareOrange)
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 5) {
                    Text("\(energy.resting + energy.active)")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                    Text("kcal")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
            }
            
            HStack {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .foregroundColor(.heathcareGreen)
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 5) {
                    Text("\(energy.dietary)")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                    Text("kcal")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
            }
            
            HStack {
                Image(systemName: "fork.knife")
                    .foregroundColor(.heathcareIrisPurple)
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 5) {
                    Text("\(energy.ingestible)")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                    Text("kcal")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Previews
struct CaloriesWidgetView_Previews: PreviewProvider {
    static var energy = Energy(resting: 1500, active: 200, dietary: 2100)
    
    static var previews: some View {
        Group {
            CaloriesWidgetMediumView(energy: energy)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            CaloriesWidgetSmallView(energy: energy)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
