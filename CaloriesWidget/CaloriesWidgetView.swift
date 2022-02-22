//
//  CaloriesWidgetView.swift
//  CaloriesWidgetExtension
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI
import WidgetKit

// MARK: - Medium Widget
struct CaloriesWidgetMediumView: View {
    var energy: Energy
    
    var body: some View {
        CaloriesView(energy: energy, textStyle: .body)
            .scaleEffect(0.92)
    }
}

// MARK: - Previews
struct CaloriesWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesWidgetMediumView(energy: Energy(resting: 0, active: 0, dietary: 0))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
