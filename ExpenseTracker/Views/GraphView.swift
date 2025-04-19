//
//  GraphView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/14/25.
//

import SwiftUI
import Charts

struct GraphView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(ExpenseManager.self) var expenseManager
    @AppStorage("isDarkMode") private var isDarkMode = false
            
    var totalsByCategory: [String: Double] {
        expenseManager.expenses.reduce(into: [String: Double]()) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }
    }
    
    var dailyTotals: [(date: Date, total: Double)] {
        let grouped = Dictionary(grouping: expenseManager.expenses) { expense in
            Calendar.current.startOfDay(for: expense.timestamp)
        }
        
        return grouped
            .map { (date, expenses) in
                (date: date, total: expenses.reduce(0) { $0 + $1.amount })
            }
            .sorted(by: { $0.date < $1.date })
    }
    
    var topExpenses: [Expense] {
        expenseManager.expenses
            .sorted(by: { $0.amount > $1.amount })
            //.prefix(5)
    }
    
    var body: some View {
        ScrollView {
            charts
                .padding()
        }
        .background(Color("background"))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .withTopToolbar(title: "Graphs")
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var barGraph: some View {
        Text("Bar Graph")
            .font(.system(size: 18))
            .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))

        Chart {
            ForEach(totalsByCategory.sorted(by: { $0.key < $1.key }), id: \.key) { category, total in
                BarMark(
                    x: .value("Category", category),
                    y: .value("Total", total)
                )
                .foregroundStyle(by: .value("Category", category))
                .annotation(position: .top) {
                    Text(total, format: .currency(code: "USD"))
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .currency(code: "USD"))
            }
        }
        .chartLegend(.hidden)
        .frame(height: 275)
        .padding(.top)
    }
    
    @ViewBuilder
    private var pieGraph: some View {
        Text("Pie Graph")
            .font(.system(size: 18))
            .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))

        let total = totalsByCategory.values.reduce(0, +)
        
        Chart {
            ForEach(totalsByCategory.sorted(by: { $0.key < $1.key }), id: \.key) { category, totalValue in
                let percentage = total > 0 ? totalValue / total : 0
                
                SectorMark(
                    angle: .value("Amount", totalValue),
                    innerRadius: .ratio(0.5),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Category", category))
                .annotation(position: .overlay) {
                    if percentage > 0.05 {
                        Text("\(Int(percentage * 100))%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(height: 275)
        .padding(.top)
    }
    
    @ViewBuilder
    private var lineChart: some View {
        Text("Line Chart")
            .font(.system(size: 18))
            .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))

        Chart {
            ForEach(dailyTotals, id: \.date) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Total", entry.total)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isDarkMode ? Color("lightBlue") : Color("darkBlue"))
                .symbol(Circle())
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.year().month().day())
            }
        }
        .chartYAxis {
            AxisMarks(format: .currency(code: "USD"))
        }
        .frame(height: 300)
        .padding()
    }
    
    @ViewBuilder
    private var topExpensesChart: some View {
        Text("Top Expenses")
            .font(.system(size: 18))
            .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))
        
        Chart {
            ForEach(topExpenses) { expense in
                BarMark(
                    x: .value("Amount", expense.amount),
                    y: .value("Name", expense.name)
                )
                .foregroundStyle(by: .value("Category", expense.category))
                .annotation(position: .trailing) {
                    Text("$\(expense.amount, specifier: "%.2f")")
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                }
            }
        }
//        .chartYAxis {
//            AxisMarks(position: .leading) { value in
//                AxisGridLine()
//                AxisTick()
//                AxisValueLabel {
//                    if let doubleValue = value.as(Double.self) {
//                        Text("$\(Int(doubleValue))")
//                    }
//                }
//            }
//        }
        .chartLegend(position: .bottom)
        .frame(height: 300)
    }

    @ViewBuilder
    private var charts: some View {
        VStack {
            topExpensesChart
                        
            Spacer()
            Spacer()
            Spacer()
            
            barGraph
            
            Spacer()
            Spacer()
            Spacer()
            
            pieGraph
            
            Spacer()
            Spacer()
            Spacer()
            
            lineChart
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthManager()) // No arguments!
        .environment(ExpenseManager(isMocked: true)) // This is fine if your ExpenseManager supports it
}
