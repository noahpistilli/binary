//
//  Decoder.swift
//  
//
//  Created by Noah Pistilli on 2023-03-05.
//


import Foundation
import NIOCore

class BinaryDecoder: Decoder {
    let codingPath: [CodingKey] = []
    let userInfo: [CodingUserInfoKey : Any] = [:]
    let endianess: ByteOrder
    var buffer: ByteBuffer
    
    init(buffer: ByteBuffer, order: ByteOrder) {
        self.buffer = buffer
        self.endianess = order
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Most likely an array was attempted to be decoded"))
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer(KeyedContainer<Key>(codingPath: self.codingPath, decoder: self))
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer(codingPath: codingPath, decoder: self)
    }
    
    func unwrap<T: Decodable>(as type: T.Type) throws -> T {
        return try T(from: self)
    }
    
    func getValueFromType<T: DataType>(_ type: T.Type) throws -> T {
        guard let bytes = self.buffer.readBytes(length: type.size) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected EOF"))
        }
        
        return T(bytes, order: self.endianess)
    }
    
    func makeUnsupportedDataTypeError(_ type: Any.Type) -> DecodingError {
        DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: [],
            debugDescription: "Type \(type) is not supported by the decoder (Type does not have a fixed size)"
        ))
    }
}


extension BinaryDecoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let codingPath: [CodingKey]
        var decoder: BinaryDecoder
        
        init(codingPath: [CodingKey], decoder: BinaryDecoder) {
            self.codingPath = codingPath
            self.decoder = decoder
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        func decode(_ type: String.Type) throws -> String {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            2
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            try self.decoder.getValueFromType(type)
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            try T(from: self.decoder)
        }
        
        func decodeNil() -> Bool {
            false
        }
    }
}

extension BinaryDecoder {
    struct KeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        typealias Key = K
        
        let codingPath: [CodingKey]
        var decoder: BinaryDecoder
        
        init(codingPath: [CodingKey], decoder: BinaryDecoder) {
            self.codingPath = codingPath
            self.decoder = decoder
        }
        
        var allKeys: [K] { [K]()  }
        
        func contains(_ key: K) -> Bool {
            // Unneeded
            return false
        }
        
        func decodeNil(forKey key: K) throws -> Bool {
            false
        }
        
        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            return try T(from: self.decoder)
        }
        
        func superDecoder() throws -> Decoder {
            self.decoder
        }
        
        func superDecoder(forKey key: K) throws -> Decoder {
            self.decoder
        }
        
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            try self.decoder.unkeyedContainer()
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            try self.decoder.container(keyedBy: type)
        }
    }
}
