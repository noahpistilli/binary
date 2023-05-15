# binary

Binary decoder for Swift. Currently supports all data types with a fixed size.

## Example
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

Support for encoding back into data and array decoding is planned.
