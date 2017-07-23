import SpriteKit

enum Theme: UInt32 {

    case red
    case green
    case blue
    case purple
    case indigo
    case gray

    var background: SKColor {
        switch self {
        case .red:
            return SKColor(red: 0.675, green: 0.29, blue: 0.2, alpha: 1)
        case .green:
            return SKColor(red: 0.48, green: 0.56, blue: 0.29, alpha: 1)
        case .blue:
            return SKColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1)
        case .purple:
            return SKColor(red: 0.31, green: 0.24, blue: 0.55, alpha: 1)
        case .indigo:
            return SKColor(red: 0.08, green: 0.39, blue: 0.39, alpha: 1)
        case .gray:
            return SKColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        }
    }

    var object: SKColor {
        switch self {
        case .red:
            return SKColor(red: 0.48, green: 0.12, blue: 0.08, alpha: 1)
        case .green:
            return SKColor(red: 0.15, green: 0.23, blue: 0.035, alpha: 1)
        case .blue:
            return SKColor(red: 0.09, green: 0.19, blue: 0.31, alpha: 1)
        case .purple:
            return SKColor(red: 0.16, green: 0.12, blue: 0.35, alpha: 1)
        case .indigo:
            return SKColor(red: 0.1, green: 0.15, blue: 0.25, alpha: 1)
        case .gray:
            return SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        }
    }

    var objectFeature: SKColor {
        switch self {
        case .red:
            return SKColor(red: 0.4, green: 0, blue: 0, alpha: 1)
        case .green:
            return SKColor(red: 0.05, green: 0.15, blue: 0.05, alpha: 1)
        case .blue:
            return SKColor(red: 0, green: 0.1, blue: 0.25, alpha: 1)
        case .purple:
            return SKColor(red: 0.1, green: 0.05, blue: 0.3, alpha: 1)
        case .indigo:
            return SKColor(red: 0.04, green: 0.085, blue: 0.15, alpha: 1)
        case .gray:
            return SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
    }

    static var random: Theme {
        return Theme(rawValue: arc4random_uniform(Theme.gray.rawValue + 1))!
    }

}
