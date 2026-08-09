import Foundation

public struct LunarTransitCandidate {
    public let instant: Date
    public let details: String?
    public init(instant: Date, details: String? = nil) {
        self.instant = instant
        self.details = details
    }
}

public final class LunarAnchorSelector {
    private let engine: AstronomicalEngine
    private let searchWindowHours: Int

    public init(engine: AstronomicalEngine, searchWindowHours: Int = 48) {
        self.engine = engine
        self.searchWindowHours = searchWindowHours
    }

    /// Search for lunar transit candidates around the target date and apply a simple nocturnal validator.
    /// This is a first-pass implementation: it requests a single lunarTransit near each day in the window
    /// and checks solar altitude at the transit instant to decide whether the transit falls within nighttime.
    public func findCandidates(around date: Date, location: GeographicLocation) throws -> [LunarTransitCandidate] {
        var candidates: [LunarTransitCandidate] = []
        let halfWindow = TimeInterval(searchWindowHours * 60 * 60) / 2.0
        let start = date.addingTimeInterval(-halfWindow)
        let end = date.addingTimeInterval(halfWindow)

        // sample at 6-hour steps across the window to find nearby transits (coarse approach for stub)
        var cursor = start
        while cursor <= end {
            do {
                let event = try engine.lunarTransit(near: cursor, location: location)
                switch event.state {
                case .occurs(let instant):
                    // Check solar altitude at the instant to determine nocturnal membership
                    do {
                        let solar = try engine.solarPosition(at: instant, location: location)
                        // Simple nocturnal rule: solar altitude < -6° (civil twilight) indicates night
                        if solar.altitude < -6.0 {
                            candidates.append(LunarTransitCandidate(instant: instant, details: event.details))
                        }
                    } catch {
                        // if solar position not available, still include with lower confidence
                        candidates.append(LunarTransitCandidate(instant: instant, details: "no-solar-check: \(error)"))
                    }
                default:
                    break
                }
            } catch {
                // swallow individual errors to continue searching
            }
            cursor = cursor.addingTimeInterval(6 * 60 * 60)
        }

        // sort by chronological order
        candidates.sort { $0.instant < $1.instant }
        return candidates
    }
}
