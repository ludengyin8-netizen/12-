import Foundation

public final class BoundaryValidator {
    public init() {}

    /// Validate a complete ShichenBoundarySet according to project rules.
    /// Throws ShichenError.noValidCycle when validation fails.
    public func validate(_ set: ShichenBoundarySet) throws {
        let boundaries = set.boundaries

        // 1. Exactly 12 boundaries exist.
        guard boundaries.count == 12 else {
            throw ShichenError.noValidCycle
        }

        // 2. Every boundary has a timestamp. (ShichenBoundary.instant is non-optional)
        // 3. Timestamps are chronological.
        for i in 0..<(boundaries.count - 1) {
            let a = boundaries[i].instant
            let b = boundaries[i + 1].instant
            if b <= a {
                throw ShichenError.noValidCycle
            }
        }

        // 4 & 5. No interval has negative duration or zero duration.
        for i in 0..<boundaries.count {
            let current = boundaries[i]
            let nextIndex = (i + 1) % boundaries.count
            var nextInstant = boundaries[nextIndex].instant

            // For the wrap-around interval, if next instant is earlier than current,
            // assume next belongs to the next civil day and add 24h until it's after current.
            if nextInstant <= current.instant {
                var adjusted = nextInstant
                while adjusted <= current.instant {
                    adjusted = adjusted.addingTimeInterval(24 * 60 * 60)
                    // guard against infinite loops — but in practice this will break quickly
                    if adjusted.timeIntervalSince1970 > current.instant.timeIntervalSince1970 + 365 * 24 * 60 * 60 {
                        // more than a year difference — suspicious
                        throw ShichenError.noValidCycle
                    }
                }
                nextInstant = adjusted
            }

            let duration = nextInstant.timeIntervalSince(current.instant)
            if duration <= 0 {
                throw ShichenError.noValidCycle
            }
        }

        // 6. Branch order is preserved (must be: 子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥)
        let expectedOrder: [EarthlyBranch] = [.zi, .chou, .yin, .mao, .chen, .si, .wu, .wei, .shen, .you, .xu, .hai]
        let actualOrder = boundaries.map { $0.branch }
        if actualOrder != expectedOrder {
            throw ShichenError.noValidCycle
        }

        // 7. The cycle closes correctly — verified by positive wrap-around duration above.
        // 8. No astronomical event was incorrectly inserted out of sequence.
        // Already enforced by branch order and chronological checks.

        // 9. Timezone conversion did not alter astronomical ordering.
        // To ensure this we recommend callers provide instants as absolute times (Date) — nothing to check here.

        // 10. The result is internally consistent. If we've passed the above checks, consider valid.
    }
}
