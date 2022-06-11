//
//  CaloriesRingView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/11.
//

import SwiftUI

struct RingView: View {
    var value: Float
    var startColor: Color
    var endColor: Color
    
    @State private var isShowed = false
    
    var body: some View {
        ZStack {
            // background
            Circle()
                .stroke(lineWidth: 15.0)
                .opacity(0.3)
                .foregroundColor(startColor.opacity(0.3))
            
            // value
            Circle()
                .trim(from: 0.0, to: CGFloat(value))
                .stroke(AngularGradient(
                    colors: [startColor, endColor],
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360 * Double(value))),
                        style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: isShowed)
            
            // Start point
            Circle()
                .frame(width: 15.0, height: 15.0)
                .foregroundColor(value > 0.95 ? startColor.opacity(0) : startColor)
                .offset(y: -60)
            
            // End point
            Circle()
                .frame(width: 15.0, height: 15.0)
                .offset(y: -60)
                .foregroundColor(value > 0.95 ? endColor : endColor.opacity(0))
                .rotationEffect(Angle(degrees: 360 * Double(value)))
                .animation(.linear, value: isShowed)
        }
        .frame(width: 120, height: 120, alignment: .center)
        .onAppear {
            isShowed.toggle()
        }
    }
}
