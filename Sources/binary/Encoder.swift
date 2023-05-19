//
//  Encoder.swift
//  
//
//  Created by Noah Pistilli on 2023-05-16.
//

import Foundation
import NIOCore

/*class BinaryEncoder: Encoder {
    let codingPath: [CodingKey] = []
    let userInfo: [CodingUserInfoKey : Any] = [:]
    var buffer: ByteBuffer
    let endianess: Endianness
    
    init(buffer: inout ByteBuffer, endianess: Endianness) {
        self.buffer = buffer
        self.endianess = endianess
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        <#code#>
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        KeyedEncodingContainer(KeyedContainer(codingPath: self.codingPath, decoder: self))
    }
}

extension BinaryEncoder {
    struct KeyedContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
        typealias Key = K
        
        let codingPath: [CodingKey]
        var encoder: BinaryEncoder
        
        init(codingPath: [CodingKey], decoder: BinaryEncoder) {
            self.codingPath = codingPath
            self.encoder = decoder
        }
        
        
        public mutating func encodeNil(forKey key: K) throws {}
        
        public mutating func encode(_ value: Bool, forKey key: Key) throws {
            
        }
        
        public mutating func encode(_ value: Int, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: Int8, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: Int16, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: Int32, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: Int64, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
            
        public mutating func encode(_ value: UInt, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
            
        public mutating func encode(_ value: UInt8, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
            
        public mutating func encode(_ value: UInt16, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: UInt32, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: UInt64, forKey key: Key) throws {
            self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: String, forKey key: Key) throws {}
        
        public mutating func encode(_ value: Double, forKey key: K) throws {
            // self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode(_ value: Float, forKey key: K) throws {
            //  self.encoder.buffer.writeInteger(value, endianness: self.encoder.endianess)
        }
        
        public mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
            
        }
        
        public mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
            <#code#>
        }
    }
}
*/
