//
//  LineChartView.swift
//  SimpleTest
//
//  Created by Shohjahon Rakhmatov on 11/02/24.
//

import SwiftUI

struct LineChartView: View {
    
    var colorCounts: [ColorCountModel] {
        var colorCounts: [ColorCountModel] = []
        for value in lineChartValues {
            let index = colorCounts.firstIndex(where: { $0.color == value.color })
            if let index {
                colorCounts[index].count += 1
            } else {
                colorCounts.append(ColorCountModel(color: value.color, count: 1))
            }
        }
        return colorCounts
    }
    var data: [LineChartValueModel] {
        return lineChartValues
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let points = calculatePoints(geometry: geometry)
                ZStack {
                    ZStack {
                        HStack(spacing: 0) {
                            ForEach(colorCounts) { count in
                                Rectangle()
                                    .fill(
                                        LinearGradient(colors: [count.color, Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .frame(width: geometry.size.width / CGFloat(data.count) * CGFloat(count.count))
                            }
                        }
                        HStack(spacing: 0) {
                            ForEach(data, id: \.id) { value in
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 1)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .clipShape(.rect(cornerRadius: 1))
                            }
                        }
                    }
                    .mask(
                        Path { path in
                            guard points.count >= 2 else { return }
                            path.move(to: CGPoint(x: points[0].x, y: geometry.size.height))
                            for i in 0..<points.count {
                                path.addLine(to: CGPoint(x: points[i].x, y: points[i].y))
                            }
                            path.addLine(to: CGPoint(x: points.last!.x, y: geometry.size.height))
                        }
                    )
                    
                    Path { path in
                        guard points.count >= 2 else { return }
                        path.move(to: points[0])
                        for i in 1..<points.count {
                            path.addLine(to: points[i])
                        }
                    }
                    .stroke(lineGradient(), lineWidth: 2)
                    .blur(radius: 2)
                }
            }
            HStack {
                Text("0%")
                Spacer()
                Text("50%")
                Spacer()
                Text("100%")
            }
            .font(.system(size: 12))
            .foregroundStyle(.text)
        }
        .frame(height: 157)
        .padding(.horizontal, 14)
        .padding(.vertical, 24)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.iconBorder)
            }
            .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
        }
    }
    
    func lineGradient() -> LinearGradient {
        var stops: [Gradient.Stop] = []
        for index in 0..<lineChartValues.count {
            let value = lineChartValues[index]
            let stop = Gradient.Stop(color: value.color, location: Double(100 / lineChartValues.count * (index + 1)) / 100)
            stops.append(stop)
        }
        return LinearGradient(gradient: Gradient(stops: stops), startPoint: .leading, endPoint: .trailing)
    }
    
    func calculatePoints(geometry: GeometryProxy) -> [CGPoint] {
        let minValue = getRageValue(isMax: false)
        let maxValue = getRageValue(isMax: true)
        let xStep = geometry.size.width / CGFloat(data.count - 1)
        let yStep = geometry.size.height / CGFloat(maxValue - minValue)
        return data.enumerated().map { index, value in
            let x = min(CGFloat(index) * xStep, geometry.size.width)
            let y = geometry.size.height - CGFloat(Double(value.value) - minValue) * yStep
            return CGPoint(x: x, y: y)
        }
    }
    
    func getRageValue(isMax: Bool) -> Double {
        var minValue = data.min(by: { $0.value < $1.value })?.value ?? 0
        var maxValue = data.max(by: { $0.value < $1.value })?.value ?? 0
        minValue = minValue * 0.0
        maxValue = maxValue * 1.01
        return isMax ? maxValue : minValue
    }
}

struct ColorCountModel: Identifiable {
    let id = UUID()
    var color: Color
    var count: Int
}

struct LineChartValueModel: Identifiable {
    let id = UUID()
    let value: Double
    let color: Color
}

let lineChartValues: [LineChartValueModel] = [
    LineChartValueModel(value: 18, color: .blueChart),
    LineChartValueModel(value: 20, color: .blueChart),
    LineChartValueModel(value: 23, color: .blueChart),
    LineChartValueModel(value: 25, color: .blueChart),
    LineChartValueModel(value: 30, color: .blueChart),
    LineChartValueModel(value: 35, color: .purpleChart),
    LineChartValueModel(value: 40, color: .purpleChart),
    LineChartValueModel(value: 60, color: .lightOrangeChart),
    LineChartValueModel(value: 75, color: .lightOrangeChart),
    LineChartValueModel(value: 85, color: .lightOrangeChart),
    LineChartValueModel(value: 95, color: .lightOrangeChart),
    LineChartValueModel(value: 100, color: .lightOrangeChart)
]

struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        LineChartView()
    }
}
