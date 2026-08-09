import XCTest
@testable import SHICHEN // 如果模块名不同请改为实际模块名
import Foundation

final class LunarSelectorTests: XCTestCase {
    // Minimal mock engine implementing only the methods used by LunarAnchorSelector
    class MockEngine: AstronomicalEngine {
        let transitInstants: [Date]
        init(transitInstants: [Date]) {
            self.transitInstants = transitInstants
        }

        // Provide a lunarTransit that returns the nearest transit from our list
        func lunarTransit(near date: Date, location: GeographicLocation) throws -> AstronomicalEvent {
            // return the first transit inside +/- 12h of the requested date, otherwise indeterminate
            for t in transitInstants {
                if abs(t.timeIntervalSince(date)) <= 12 * 60 * 60 {
                    return AstronomicalEvent(name: "lunarTransit", state: .occurs(t), details: "mock")
                }
            }
            return AstronomicalEvent(name: "lunarTransit", state: .indeterminate, details: "none")
        }

        // Minimal solarPosition used for nocturnal check: always return altitude -10° (night)
        func solarPosition(at instant: Date, location: GeographicLocation) throws -> (altitude: Double, azimuth: Double, hourAngle: Double) {
            return (-10.0, 0.0, 0.0)
        }

        // All other protocol requirements — implement as throws or indeterminate
        func sunrise(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "sunrise", state: .indeterminate, details: nil) }
        func sunset(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "sunset", state: .indeterminate, details: nil) }
        func solarTransit(near date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "solarTransit", state: .indeterminate, details: nil) }
        func moonrise(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "moonrise", state: .indeterminate, details: nil) }
        func moonset(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "moonset", state: .indeterminate, details: nil) }
        func lunarPosition(at instant: Date, location: GeographicLocation) throws -> (altitude: Double, azimuth: Double, hourAngle: Double) { return (0,0,0) }
        func civilDawn(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "civilDawn", state: .indeterminate, details: nil) }
        func civilDusk(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "civilDusk", state: .indeterminate, details: nil) }
        func nauticalDawn(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "nauticalDawn", state: .indeterminate, details: nil) }
        func nauticalDusk(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "nauticalDusk", state: .indeterminate, details: nil) }
        func astronomicalDawn(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "astronomicalDawn", state: .indeterminate, details: nil) }
        func astronomicalDusk(on date: Date, location: GeographicLocation) throws -> AstronomicalEvent { return AstronomicalEvent(name: "astronomicalDusk", state: .indeterminate, details: nil) }
    }

    func testFindsNightlyLunarTransitCandidates() throws {
        let now = Date()
        // create a transit near 'now'
        let transit = now.addingTimeInterval(2 * 60 * 60) // +2h
        let engine = MockEngine(transitInstants: [transit])
        // a simple location; adjust constructor if your GeographicLocation init differs
        let location = GeographicLocation(latitude: 0.0, longitude: 0.0, elevationMeters: 0.0, timeZone: TimeZone(secondsFromGMT: 0)!)
        let selector = LunarAnchorSelector(engine: engine, searchWindowHours: 48)
        let candidates = try selector.findCandidates(around: now, location: location)
        XCTAssertFalse(candidates.isEmpty, "expected at least one lunar transit candidate during night")
        XCTAssertTrue(candidates.contains { abs($0.instant.timeIntervalSince(transit)) < 1.0 }, "candidate instants should include our mock transit")
    }
}
