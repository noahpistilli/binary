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
    
    /// Hack for fixed size arrays
    let arrayInfo: [String : Int]
    
    let endianess: Endianness
    
    var buffer: ByteBuffer
    
    var lastKey: CodingKey?
    
    init(buffer: ByteBuffer, order: Endianness, arrayInfo: [String : Int]) {
        self.arrayInfo = arrayInfo
        self.buffer = buffer
        self.endianess = order
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try UnkeyedContainer(decoder: self, arrayInfo: self.arrayInfo)
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
            throw self.decoder.makeUnsupportedDataTypeError(type)
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
            self.decoder.lastKey = key
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

extension BinaryDecoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        var codingPath: [CodingKey] = []
        
        var decoder: BinaryDecoder
        
        let count: Int?
        
        let arrayInfo: [String : Any]
        
        var isAtEnd: Bool { self.currentIndex >= (self.count!) }
        
        var currentIndex: Int = 0
        
        init(decoder: BinaryDecoder, arrayInfo: [String : Any]) throws {
            guard let _count = decoder.arrayInfo[decoder.lastKey!.stringValue] else {
                throw DecodingError.keyNotFound(decoder.lastKey!, .init(codingPath: [decoder.lastKey!], debugDescription: "Key \(decoder.lastKey!.stringValue) was not specified in the arrayInfo parameter."))
            }
            
            self.arrayInfo = arrayInfo
            self.decoder = decoder
            self.count = _count
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        func decode(_ type: String.Type) throws -> String {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        mutating func decode(_ type: Float.Type) throws -> Float {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: Int.Type) throws -> Int {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        mutating func decode(_ type: UInt.Type) throws -> UInt {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            let val = try self.decoder.getValueFromType(type)
            currentIndex += 1
            return val
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            throw self.decoder.makeUnsupportedDataTypeError(type)
        }
        
        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let val = try T(from: self.decoder)
            currentIndex += 1
            return val
        }
        
        func decodeNil() -> Bool {
            false
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let val = try self.decoder.container(keyedBy: type)
            currentIndex += 1
            return val
        }
        
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let val = try self.decoder.unkeyedContainer()
            currentIndex += 1
            return val
        }
        
        func superDecoder() throws -> Decoder {
            self.decoder
        }
    }
}
