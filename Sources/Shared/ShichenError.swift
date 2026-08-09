import Foundation

public enum ShichenError: Error {
    case invalidCoordinates
    case astronomicalCalculationFailed
    case missingRequiredEvent
    case noValidLunarTransit
    case noValidCycle
    case unsupportedPolarCondition
    case timezoneFailure
    case notImplemented
}
