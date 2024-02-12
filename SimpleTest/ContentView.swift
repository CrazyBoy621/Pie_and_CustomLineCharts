//
//  ContentView.swift
//  SimpleTest
//
//  Created by Shohjahon Rakhmatov on 11/02/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    let expenses: [ExpenseModel] = [
        ExpenseModel(name: "ゲーム", date: Date(), type: .enterainment, amount: 32760),
        ExpenseModel(name: "美容院", date: Date(), type: .beauty, amount: 30000),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                TopChartView()
                VStack(spacing: 16) {
                    TitleView("影響している要素")
                    VStack(spacing: 8) {
                        SubtitleView("決済額上位の代表例")
                        ForEach(expenses) { expense in
                            ExpenseView(expense)
                        }
                    }
                    VStack(spacing: 8) {
                        SubtitleView("細かい決済の内訳")
                        ChartView()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.cardBackground)
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 30)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder func TitleView(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.blackText)
    }
    
    @ViewBuilder func ExpenseView(_ expense: ExpenseModel) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text(expense.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.blackText)
                HStack(spacing: 8) {
                    Text(formattedDate(expense.date))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondaryText)
                    HStack(spacing: 4) {
                        Circle()
                            .fill(expense.type.model.color.opacity(0.2))
                            .frame(height: 8)
                            .overlay {
                                Circle()
                                    .fill(expense.type.model.color)
                                    .padding(2)
                            }
                        Text(expense.type.model.name)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondaryDark)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("¥\(expense.amount)")
                .foregroundStyle(.blackText)
                .font(.poppins(size: 16))
        }
    }
    
    @ViewBuilder func SubtitleView(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundStyle(.text)
            Rectangle()
                .fill(Color.iconBorder)
                .frame(height: 1)
        }
    }
    
    @ViewBuilder func ChartView() -> some View {
        HStack {
            PieChartView()
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                ForEach(chartValues) { value in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(value.color)
                            .frame(width: 8)
                        Text(value.name)
                            .font(.system(size: 12))
                            .foregroundStyle(.text)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder func TopChartView() -> some View {
        LineChartView()
            .overlay {
                HStack {
                    PercentageChartView("低位", 35)
                        .offset(x: -50)
                    PercentageChartView("中位", 25)
                        .offset(x: 15, y: -15)
                    PercentageChartView("決済額上位", 40)
                        .offset(x: 30, y: -60)
                }
            }
    }
    
    @ViewBuilder func PercentageChartView(_ title: String, _ percentage: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
            Text("\(percentage)%")
                .fontWeight(.regular)
        }
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(.text)
    }
    
    func formattedDate(_ day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: day)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

struct ExpenseModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let type: ExpenseType
    let amount: Int
}

enum ExpenseType {
    case enterainment
    case beauty
    
    var model: ExpenditureModel {
        switch self {
        case .enterainment:
            return ExpenditureModel(name: "娯楽費", color: .purpleChart)
        case .beauty:
            return ExpenditureModel(name: "美容", color: .darkBlueChart)
        }
    }
}

struct ExpenditureModel {
    let name: String
    let color: Color
}


