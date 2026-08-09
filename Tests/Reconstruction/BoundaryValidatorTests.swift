import XCTest
@testable import SHICHEN

final class BoundaryValidatorTests: XCTestCase {
    func testValidBoundarySetDoesNotThrow() throws {
        let now = Date()
        var boundaries: [ShichenBoundary] = []
        let branches: [EarthlyBranch] = [.zi, .chou, .yin, .mao, .chen, .si, .wu, .wei, .shen, .you, .xu, .hai]
        for i in 0..<12 {
            let instant = now.addingTimeInterval(TimeInterval(i * 60 * 60)) // 1 hour apart
            let b = ShichenBoundary(branch: branches[i], instant: instant, basis: .fallbackSolarPhase, confidence: .indeterminate)
            boundaries.append(b)
        }
        let set = ShichenBoundarySet(boundaries: boundaries)
        let validator = BoundaryValidator()
        XCTAssertNoThrow(try validator.validate(set))
    }

    func testWrongCountThrowsNoValidCycle() {
        let set = ShichenBoundarySet(boundaries: [])
        let validator = BoundaryValidator()
        XCTAssertThrowsError(try validator.validate(set)) { error in
            XCTAssertEqual(error as? ShichenError, ShichenError.noValidCycle)
        }
    }

    func testNonChronologicalTimestampsThrow() {
        let now = Date()
        var boundaries: [ShichenBoundary] = []
        let branches: [EarthlyBranch] = [.zi, .chou, .yin, .mao, .chen, .si, .wu, .wei, .shen, .you, .xu, .hai]
        for i in 0..<12 {
            let instant = now.addingTimeInterval(TimeInterval((i == 5 ? -10 : i) * 60 * 60)) // introduce out-of-order at index 5
            let b = ShichenBoundary(branch: branches[i], instant: instant, basis: .fallbackSolarPhase, confidence: .indeterminate)
            boundaries.append(b)
        }
        let set = ShichenBoundarySet(boundaries: boundaries)
        let validator = BoundaryValidator()
        XCTAssertThrowsError(try validator.validate(set)) { error in
            XCTAssertEqual(error as? ShichenError, ShichenError.noValidCycle)
        }
    }
}
