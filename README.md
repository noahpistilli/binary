# binary

Binary decoder for Swift. Currently supports most data types with a fixed size + fixed arrays.
> Integers with a size of 8 bytes such as (U)Int64 and Double are currently not supported.

## Examples
### Basic Decoding
Below is an example of reading a simple data buffer into a struct.
```swift
struct ReadTest: Decodable {
    let a: UInt8
    let b: UInt16
    let c: UInt32
}

struct TestReadNestedValues: Decodable {
    let a: UInt16
    let b: ReadTest
}

let contents = Data([1, 2, 4, 4, 4, 4, 4, 4, 4])
let a = try binary.Read(data: contents, order: .bigEndian, type: TestReadNestedValues.self)

XCTAssertEqual(a.a, 258)
XCTAssertEqual(a.b.a, 4)
XCTAssertEqual(a.b.b, 1028)
XCTAssertEqual(a.b.c, 67372036)
```

Data can be either Swift type `Data` or a `ByteBuffer`.

### Fixed Arrays
Swift does not support fixed arrays which can pose an issue in binary decoding where you may need to skip a few bytes due to padding or unknown values among other things.

This package supports fixed arrays by using the CodingKeys in the struct you are decoding.
```swift
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
```

To create a fixed array, declare the array type in the struct you are decoding, then make a dictionary with the key being the CodingKey associated with the array and the value being the size. Pass this dictionary to the `arrayInfo` parameter.
