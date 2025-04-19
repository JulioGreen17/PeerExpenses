//
//  ExpenseRow.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/14/25.
//

import SwiftUI

struct ExpenseRow: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var expense: Expense
    
    static let icons: [String: String] = [
        "Food": "fork.knife",
        "Transport": "car.fill",
        "Entertainment": "gamecontroller.fill",
        "Utilities": "gearshape.fill",
        "Other": "square.grid.2x2.fill"
    ]
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.clear)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: ExpenseRow.icons[expense.category] ?? "square.grid.2x2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))
                }
                .padding(.trailing, 7)

            VStack(alignment: .leading, spacing: 6) {
                Text(expense.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .lineLimit(1)
                
                Text(expense.category)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                Text(expense.timestamp, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(expense.amount, format: .currency(code: "USD"))
                .bold()
                .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))
        }
        .padding()
        .background(isDarkMode ? Color.black.opacity(0.5) : Color.white.opacity(0.5))
    }
}

#Preview {
    ExpenseRow(expense: Expense(name: "Rent", amount: 100, category: "Utilities", username: "test@gmail.com"))
}
