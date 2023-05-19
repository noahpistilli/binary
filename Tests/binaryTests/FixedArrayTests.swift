import XCTest
@testable import binary
import NIOCore

final class FixedArrayDecodingTests: XCTestCase {
    struct FixedArrayTest: Decodable {
        let a: [UInt8]
        let b: [UInt16]
        let c: [UInt32]
    }
    
    func testFixedArraySize() throws {
        let contents = Data([1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4])
        let a = try binary.Read(data: contents, order: .big, arrayInfo: ["a" : 2, "b": 2, "c": 2],  type: FixedArrayTest.self)
            
        XCTAssertEqual(a.a[0], 1)
        XCTAssertEqual(a.a[1], 2)
        XCTAssertEqual(a.b[0], 1028)
        XCTAssertEqual(a.b[1], 1028)
        XCTAssertEqual(a.c[0], 67372036)
        XCTAssertEqual(a.c[1], 67372036)
    }
}
