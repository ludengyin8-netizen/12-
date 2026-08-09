import Foundation

public final class StubAstronomicalEngine: AstronomicalEngine {
    public init() {}

    public func solarPosition(at instant: Date, location: GeographicLocation) throws -> (altitude: Double, azimuth: Double, hourAngle: Double) {
        throw ShichenError.notImplemented
    }

    public func lunarPosition(at instant: Date, location: GeographicLocation) throws -> (altitude: Double, azimuth: Double, hourAngle: Double) {
        throw ShichenError.notImplemented
    }

    public func sunrise(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "sunrise", state: .indeterminate, details: "stub: indeterminate")
    }

    public func sunset(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "sunset", state: .indeterminate, details: "stub: indeterminate")
    }

    public func solarTransit(near date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "solarTransit", state: .indeterminate, details: "stub: indeterminate")
    }

    public func moonrise(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "moonrise", state: .indeterminate, details: "stub: indeterminate")
    }

    public func moonset(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "moonset", state: .indeterminate, details: "stub: indeterminate")
    }

    public func lunarTransit(near date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "lunarTransit", state: .indeterminate, details: "stub: indeterminate")
    }

    public func civilDawn(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "civilDawn", state: .indeterminate, details: "stub: indeterminate")
    }

    public func civilDusk(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "civilDusk", state: .indeterminate, details: "stub: indeterminate")
    }

    public func nauticalDawn(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "nauticalDawn", state: .indeterminate, details: "stub: indeterminate")
    }

    public func nauticalDusk(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "nauticalDusk", state: .indeterminate, details: "stub: indeterminate")
    }

    public func astronomicalDawn(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "astronomicalDawn", state: .indeterminate, details: "stub: indeterminate")
    }

    public func astronomicalDusk(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
        return AstronomicalEvent(name: "astronomicalDusk", state: .indeterminate, details: "stub: indeterminate")
    }
}
