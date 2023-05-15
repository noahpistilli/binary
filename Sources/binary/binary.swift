import Foundation
import NIOCore

public enum ByteOrder {
    case bigEndian
    case littleEndian
}

public func Read<T: Decodable>(data: ByteBuffer, order: ByteOrder, type: T.Type) throws -> T {
    return try BinaryDecoder(buffer: data, order: order).unwrap(as: T.self)
}

public func Read<T: Decodable>(data: Data, order: ByteOrder, type: T.Type) throws -> T {
    try Read(data: ByteBuffer(bytes: data), order: order, type: type)
}
