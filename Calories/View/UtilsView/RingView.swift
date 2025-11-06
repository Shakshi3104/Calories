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
    
    var lineWidth = 15.0
    var size: CGFloat = 120
    
    var systemImageName: String? = nil
    
    @State private var isShowed = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // background
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(startColor)
            
            // value
            Circle()
                .trim(from: 0.0, to: CGFloat(value))
                .stroke(AngularGradient(
                    colors: [startColor, endColor],
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360 * Double(value))),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: isShowed)
            
            // Start point
            Circle()
                .frame(width: lineWidth, height: lineWidth)
                .foregroundColor(value < 0.01 ? endColor : endColor.opacity(0))
                .offset(y: -size / 2.0)
            
            // End point
            Circle()
                .frame(width: lineWidth, height: lineWidth)
                .offset(y: -size / 2.0)
                .foregroundColor(value > 0.85 ? endColor : endColor.opacity(0))
                .rotationEffect(Angle(degrees: 360 * Double(value)))
                .animation(.linear, value: isShowed)
            
            if let systemImageName = systemImageName {
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: lineWidth * 0.6, height: lineWidth * 0.6)
                    .offset(y: -size / 2.0)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
            }
        }
        .frame(width: size, height: size, alignment: .center)
        .onAppear {
            isShowed.toggle()
        }
    }
}
