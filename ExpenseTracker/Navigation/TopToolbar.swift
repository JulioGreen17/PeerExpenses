//
//  TopToolbar.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/14/25.
//

import SwiftUI

struct TopToolbar: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var title: String
    
    func body(content: Content) -> some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .bold()
                            .font(.system(size: 22))
                            .foregroundColor(isDarkMode ? Color("lightBlue") : Color("darkBlue"))
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color("background"), for: .navigationBar)
                .background(Color("background"))
        }
    }
}

extension View {
    func withTopToolbar(title: String) -> some View {
        self.modifier(TopToolbar(title: title))
    }
}
