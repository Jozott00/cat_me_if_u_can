@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func test_tunnelGeneration() throws {
        while true {
            let tunnel = generateTunnels()
            print("Tunnel generated")
            sleep(1)
        }
    }
}
