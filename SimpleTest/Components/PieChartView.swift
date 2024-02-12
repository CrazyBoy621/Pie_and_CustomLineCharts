//
//  PieChartView.swift
//  SimpleTest
//
//  Created by Shohjahon Rakhmatov on 11/02/24.
//

import SwiftUI

struct PieChartView: View {
    
    var values: [Double] {
        var allValues: [Double] = []
        var currentValue: Double = 0
        for value in chartValues {
            let percentage = currentValue + Double(value.percentage) * 1.8
            currentValue += Double(value.percentage) * 3.6
            allValues.append(percentage)
        }
        return allValues
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    ForEach(chartValues.indices, id: \.self) { index in
                        let startAngle = index == 0 ? 0 : chartValues[0..<index].map { Double($0.percentage) }.reduce(0, +) * 3.6
                        let endAngle = startAngle + Double(chartValues[index].percentage) * 3.6
                        
                        Path { path in
                            path.move(to: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5))
                            path.addArc(center: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5),
                                        radius: min(geometry.size.width, geometry.size.height) * 0.48,
                                        startAngle: Angle(degrees: startAngle - 90),
                                        endAngle: Angle(degrees: endAngle - 90),
                                        clockwise: false)
                        }
                        .fill(chartValues[index].color)
                    }
                    Circle()
                        .frame(width: min(geometry.size.width, geometry.size.height) * 0.6)
                        .foregroundColor(.white)
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                ZStack {
                    ForEach(0..<chartValues.count, id: \.self) { index in
                        let value = chartValues[index]
                        Text("\(value.percentage)%")
                            .foregroundStyle(.text)
                            .font(.system(size: 12))
                            .rotationEffect(Angle(degrees: -values[index] + 90))
                            .offset(x: geometry.size.width * 0.525)
                            .rotationEffect(Angle(degrees: values[index]))
                    }
                }
                .rotationEffect(Angle(degrees: -90))
            }
        }
        .frame(width: 100, height: 100)
    }
}


struct ChartModel: Identifiable {
    let id = UUID()
    let name: String
    let percentage: Int
    let color: Color
}

let chartValues: [ChartModel] = [
    ChartModel(name: "ショッピング / 日用品・消耗品", percentage: 26, color: .lightBlueChart),
    ChartModel(name: "医療費 / 健康維持", percentage: 18, color: .darkBlueChart),
    ChartModel(name: "光熱費 / ガス代", percentage: 8, color: .greenChart),
    ChartModel(name: "食費 / カフェ", percentage: 20, color: .orangeChart),
    ChartModel(name: "娛楽費 / 映画", percentage: 28, color: .pinkChart)
]

#Preview {
    PieChartView()
}
