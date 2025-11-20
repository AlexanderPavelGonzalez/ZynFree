//
//  AppTheme.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import SwiftUI

struct AppTheme {
    // MARK: - Colors
    
    // Light Theme
    struct Light {
        static let primary = Color(hex: "#A8E6A3")
        static let background = Color(hex: "#FAFAFA")
        static let cardBackground = Color.white
        static let text = Color(hex: "#2C2C2C")
        static let secondaryText = Color(hex: "#666666")
    }
    
    // Dark Theme
    struct Dark {
        static let primary = Color(hex: "#7FB3A3")
        static let background = Color(hex: "#121212")
        static let cardBackground = Color(hex: "#1E1E1E")
        static let text = Color(hex: "#E0E0E0")
        static let secondaryText = Color(hex: "#B0B0B0")
    }
    
    // Adaptive colors that switch based on color scheme
    static func primaryColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.primary : Light.primary
    }
    
    static func backgroundColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.background : Light.background
    }
    
    static func cardBackgroundColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.cardBackground : Light.cardBackground
    }
    
    static func textColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.text : Light.text
    }
    
    static func secondaryTextColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.secondaryText : Light.secondaryText
    }
    
    // MARK: - Spacing
    static let spacing: CGFloat = 16
    static let spacingLarge: CGFloat = 24
    static let spacingSmall: CGFloat = 8
    static let spacingXLarge: CGFloat = 32
    
    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 24
    
    // MARK: - Shadow
    static func shadow(for scheme: ColorScheme) -> Shadow {
        Shadow(
            color: scheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.1),
            radius: scheme == .dark ? 10 : 8,
            x: 0,
            y: scheme == .dark ? 4 : 2
        )
    }
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.spacingLarge)
            .background(AppTheme.cardBackgroundColor(for: colorScheme))
            .cornerRadius(AppTheme.cornerRadius)
            .shadow(
                color: AppTheme.shadow(for: colorScheme).color,
                radius: AppTheme.shadow(for: colorScheme).radius,
                x: AppTheme.shadow(for: colorScheme).x,
                y: AppTheme.shadow(for: colorScheme).y
            )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.primaryColor(for: colorScheme))
            .cornerRadius(AppTheme.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

