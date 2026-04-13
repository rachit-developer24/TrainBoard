//
//  AppBackground.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 13/04/2026.
//

import SwiftUI

struct ElegantBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.06, blue: 0.09),
                    Color(red: 0.08, green: 0.09, blue: 0.13),
                    Color(red: 0.03, green: 0.04, blue: 0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [
                    Color.white.opacity(0.07),
                    Color.clear
                ],
                center: .top,
                startRadius: 20,
                endRadius: 320
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 220, height: 220)
                        .blur(radius: 50)
                        .offset(x: -40, y: -80)

                    Spacer()
                }

                Spacer()

                HStack {
                    Spacer()

                    Circle()
                        .fill(Color.white.opacity(0.04))
                        .frame(width: 260, height: 260)
                        .blur(radius: 60)
                        .offset(x: 60, y: 100)
                }
            }
            .ignoresSafeArea()

           
        }
    }
}
#Preview {
    ElegantBackground()
}
