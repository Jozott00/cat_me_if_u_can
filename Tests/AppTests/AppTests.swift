@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }

    func testThreadSafe() throws {
        let threadSafe = ThreadSafe(element: RefArray<Int>())

        DispatchQueue.concurrentPerform(iterations: 1000) { _ in
            threadSafe.op { elem in
                let last = elem().last ?? 0
                elem().add(ws: last + 1)
            }
        }
    }

    func testJsonDecode() throws {
        let json = """
        {
            "type": "failure",
            "failure": {
                "code": 404,
                "msg": "Hello World"
            }
        }
        """

        _ = try JSONDecoder().decode(ProtocolMessage.self, from: json.data(using: .utf8)!)
    }
}
