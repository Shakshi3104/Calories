//
//  CaloriesRingView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/11.
//

import SwiftUI

struct CaloriesRingView: View {
    var energy: Energy
    
    var body: some View {
        ZStack {
            RingView(value: Float(energy.dietary) / Float(energy.active + energy.resting),
                     startColor: .heathcareLightGreen,
                     endColor: .heathcareGreen)
            
            VStack(spacing: 7) {
                if energy.ingestible >= 0 {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                }
            
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(energy.ingestible)")
                        .font(.system(.title3, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                    Text("kcal")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.bottom, 2)
                }
            }
        }
    }
}

// MARK: -
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

struct CaloriesRingView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesRingView(energy: Energy(resting: 1500,
                                        active: 200,
                                        dietary: 1600))
    }
}
