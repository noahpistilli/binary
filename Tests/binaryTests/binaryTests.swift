import XCTest
@testable import binary

final class binaryDecodingTests: XCTestCase {
    struct ReadTest: Decodable {
        let a: UInt8
        let b: UInt16
        let c: UInt32
    }
    
    func testReadBigEndian() throws {
        let contents = Data([1, 2, 4, 4, 4, 4, 4])
        let a = try binary.Read(data: contents, order: .big, type: ReadTest.self)
        XCTAssertEqual(a.a, 1)
        XCTAssertEqual(a.b, 516)
        XCTAssertEqual(a.c, 67372036)
    }
    
    struct TestReadNestedValues: Decodable {
        let a: UInt16
        let b: ReadTest
    }
        
    func testNestedValues() throws {
        let contents = Data([1, 2, 4, 4, 4, 4, 4, 4, 4])
        let a = try binary.Read(data: contents, order: .big, type: TestReadNestedValues.self)
        XCTAssertEqual(a.a, 258)
        XCTAssertEqual(a.b.a, 4)
        XCTAssertEqual(a.b.b, 1028)
        XCTAssertEqual(a.b.c, 67372036)
    }
}
