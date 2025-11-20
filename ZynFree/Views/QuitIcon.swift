//
//  QuitIcon.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct QuitIcon: View {
    var size: CGFloat = 100
    var backgroundColor: Color = AppTheme.Light.primary // Theme green color
    var zColor: Color = .black
    var circleColor: Color = .red
    var slashColor: Color = .red
    var circleLineWidth: CGFloat = 4
    var slashLineWidth: CGFloat = 6
    
    var body: some View {
        ZStack {
            // Theme green background circle
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            // Red circle outline
            Circle()
                .stroke(circleColor, lineWidth: circleLineWidth)
                .frame(width: size, height: size)
            
            // Black letter Z (bigger size)
            Text("Z")
                .font(.system(size: size * 0.7, weight: .bold, design: .rounded))
                .foregroundColor(zColor)
            
            // Red diagonal slash (prohibition line from top-left to bottom-right)
            Path { path in
                let radius = size * 0.45
                let center = size / 2
                let diagonalLength = radius * sqrt(2)
                
                // Start point (top-left area of circle)
                let startX = center - diagonalLength / 2
                let startY = center - diagonalLength / 2
                
                // End point (bottom-right area of circle)
                let endX = center + diagonalLength / 2
                let endY = center + diagonalLength / 2
                
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            .stroke(slashColor, style: StrokeStyle(lineWidth: slashLineWidth, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: 40) {
        QuitIcon(size: 100)
        QuitIcon(size: 60)
        QuitIcon(size: 150)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}

