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
            // Extends to the circle border, accounting for the stroke width
            Path { path in
                let center = size / 2
                // Use actual radius to edge of circle (accounting for stroke being centered)
                let radius = size / 2 - circleLineWidth / 2
                
                // Calculate diagonal from center to edge
                let diagonalOffset = radius * sqrt(2) / 2
                
                // Start point (top-left area, extending slightly beyond border for visual connection)
                let startX = center - diagonalOffset
                let startY = center - diagonalOffset
                
                // End point (bottom-right area, extending slightly beyond border)
                let endX = center + diagonalOffset
                let endY = center + diagonalOffset
                
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            .stroke(slashColor, style: StrokeStyle(lineWidth: slashLineWidth, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - App Icon Helper
extension QuitIcon {
    /// Creates a view suitable for app icon with black background
    static func appIcon(size: CGFloat = 1024) -> some View {
        ZStack {
            // Black background
            Color.black
                .frame(width: size, height: size)
            
            // Icon centered with appropriate sizing
            QuitIcon(
                size: size * 0.8,  // Use 80% of canvas size for padding
                backgroundColor: AppTheme.Light.primary,
                zColor: .black,
                circleColor: .red,
                slashColor: .red,
                circleLineWidth: size * 0.004,  // Scale line width proportionally
                slashLineWidth: size * 0.006    // Scale line width proportionally
            )
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
    .background(Color.black)
}

