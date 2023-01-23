//
//  GradientPalitra.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 22.01.2023.
//

import UIKit

enum ColorPalette: String, CaseIterable {
    case firstGameStartColor
    case secondGameEndColor
    case secondGameStartColor
    case firstGameEndColor
    case cashAmountLabelStartColor
    case cashAmountLabelEndColor
    
    var color: UIColor {
        switch self {
        case .firstGameStartColor: return UIColor(red: 0.39, green: 0.84, blue: 0.98, alpha: 1)
        case .firstGameEndColor: return UIColor(red: 0.03, green: 0.45, blue: 0.79, alpha: 1)
        case .secondGameStartColor: return UIColor(red: 0.65, green: 0.98, blue: 0.98, alpha: 1)
        case .secondGameEndColor: return UIColor(red: 0.03, green: 0.79, blue: 0.24, alpha: 1)
        case .cashAmountLabelStartColor: return UIColor(red: 0.93, green: 0.47, blue: 0.25, alpha: 1)
        case .cashAmountLabelEndColor: return UIColor(red: 0.95, green: 0.65, blue: 0.31, alpha: 1)
        }
    }
}
