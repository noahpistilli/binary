import Foundation
import NIOCore

public func Read<T: Decodable>(data: ByteBuffer, order: Endianness, arrayInfo: [String : Int] = [:], type: T.Type) throws -> T {
    return try BinaryDecoder(buffer: data, order: order, arrayInfo: arrayInfo).unwrap(as: T.self)
}

public func Read<T: Decodable>(data: Data, order: Endianness, arrayInfo: [String : Int] = [:], type: T.Type) throws -> T {
    try Read(data: ByteBuffer(bytes: data), order: order, arrayInfo: arrayInfo, type: type)
}
