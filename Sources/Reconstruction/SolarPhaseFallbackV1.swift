import Foundation

public final class SolarPhaseFallbackV1: ShichenReconstructionModel {
    public init() {}

    /// Construct boundaries for the daylight half of the cycle using normalized solar phase.
    /// This is a fallback model and must be explicitly labeled as such.
    /// It requires sunrise, solarTransit, and sunset to all 'occur'.
    public func reconstruct(context: AstronomicalContext) throws -> ShichenBoundarySet {
        let engine = contextLocationEngineProvider(context: context)

        // Obtain required solar anchors
        let sunriseEvent = try engine.sunrise(on: context.date, location: context.location)
        let transitEvent = try engine.solarTransit(near: context.date, location: context.location)
        let sunsetEvent = try engine.sunset(on: context.date, location: context.location)

        guard case .occurs(let sunrise) = sunriseEvent.state,
              case .occurs(let transit) = transitEvent.state,
              case .occurs(let sunset) = sunsetEvent.state else {
            throw ShichenError.missingRequiredEvent
        }

        // Daytime fractions (0.0 -> sunrise, 1.0 -> transit)
        func interpolate(_ t: Double, start: Date, end: Date) -> Date {
            let interval = end.timeIntervalSince(start)
            return start.addingTimeInterval(interval * t)
        }

        // Mao = sunrise
        let mao = ShichenBoundary(branch: .mao, instant: sunrise, basis: .sunrise, confidence: .high)
        // Chen = 1/3 between sunrise and transit
        let chenInstant = interpolate(1.0/3.0, start: sunrise, end: transit)
        let chen = ShichenBoundary(branch: .chen, instant: chenInstant, basis: .fallbackSolarPhase, confidence: .indeterminate)
        // Si = 2/3 between sunrise and transit
        let siInstant = interpolate(2.0/3.0, start: sunrise, end: transit)
        let si = ShichenBoundary(branch: .si, instant: siInstant, basis: .fallbackSolarPhase, confidence: .indeterminate)
        // Wu = solar transit
        let wu = ShichenBoundary(branch: .wu, instant: transit, basis: .solarUpperTransit, confidence: .high)
        // Wei = 1/3 between transit and sunset
        let weiInstant = interpolate(1.0/3.0, start: transit, end: sunset)
        let wei = ShichenBoundary(branch: .wei, instant: weiInstant, basis: .fallbackSolarPhase, confidence: .indeterminate)
        // Shen = 2/3 between transit and sunset
        let shenInstant = interpolate(2.0/3.0, start: transit, end: sunset)
        let shen = ShichenBoundary(branch: .shen, instant: shenInstant, basis: .fallbackSolarPhase, confidence: .indeterminate)
        // You = sunset
        let you = ShichenBoundary(branch: .you, instant: sunset, basis: .sunset, confidence: .high)

        // The fallback model produces only the daylight-related boundaries in this initial version.
        // Zi, Chou, Yin, and boundaries around midnight require lunar anchors or nocturnal models and
        // are left to the HistoricalReconstruction or LunarAnchorSelector to provide.

        let daytimeBoundaries: [ShichenBoundary] = [mao, chen, si, wu, wei, shen, you]

        return ShichenBoundarySet(boundaries: daytimeBoundaries)
    }

    // Helper to obtain an engine from context. For now use a simple lookup — in a full implementation
    // the AstronomicalEngine would be passed in via dependency injection on the model.
    private func contextLocationEngineProvider(context: AstronomicalContext) -> AstronomicalEngine {
        // As a placeholder, initialize a stub engine. In real usage the engine should be injected.
        return StubAstronomicalEngine()
    }
}
