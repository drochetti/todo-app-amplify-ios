extension Priority {
    static var all: [Priority] { [.low, .normal, .high] }

    static func fromLabel(_ label: String) -> Self {
        switch label {
        case "Low":
            return .low
        case "Normal":
            return .normal
        case "High":
            return .high
        default:
            return .normal
        }
    }

    var label: String {
        switch self {
        case .low:
            return "Low"
        case .normal:
            return "Normal"
        case .high:
            return "High"
        }
    }
}
