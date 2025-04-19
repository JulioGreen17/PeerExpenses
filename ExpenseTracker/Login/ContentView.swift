//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 2/06/25.
//
import SwiftUI

struct ContentView: View {
    @State private var hasStarted = false

    // 🎨 New gradient colors
    let neonPurple = Color(red: 191/255, green: 64/255, blue: 255/255)
    let neonGreen = Color(red: 57/255, green: 255/255, blue: 20/255)

    var gradient: Gradient {
        Gradient(colors: [neonPurple, neonGreen])
    }

    let backgroundColor = Color.black // or any contrast background you'd like

    var body: some View {
        ZStack {
            backgroundColor

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .frame(width: 2000, height: hasStarted ? 550 : 1000)
                .rotationEffect(.degrees(hasStarted ? -45 : 0))
                .offset(y: hasStarted ? 310 : 0)

            VStack(spacing: 20) {
                Text("Expenses") // ✅ Changed from "Xpense"
                    .foregroundStyle(hasStarted ? Color.black : Color.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: hasStarted ? -100 : 0, y: hasStarted ? -250 : 0)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.spring(response: 0.9, dampingFraction: 0.9, blendDuration: 0)) {
                    hasStarted.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
