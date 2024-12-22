//
//  UIColor+Extension.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjustBrightness(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjustBrightness(by: -abs(percentage))
    }

    private func adjustBrightness(by percentage: CGFloat) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage / 100.0, 1.0),
                green: min(green + percentage / 100.0, 1.0),
                blue: min(blue + percentage / 100.0, 1.0),
                alpha: alpha
            )
        }
        return nil
    }
}
