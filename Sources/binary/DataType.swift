//
//  DataType.swift
//  
//
//  Created by Noah Pistilli on 2023-03-04.
//

import Foundation
import NIOCore

// TODO: Add u64 and s64; The Swift compiler does not like the bitwise way.

/// DataType represents a data type that can be used with the binary library
public protocol DataType: Codable {
    static var size: Int { get }
    
    init(_ b: [UInt8], order: Endianness)
}

extension UInt8: DataType {
    public static var size: Int {
        MemoryLayout<UInt8>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        self.init(b[0])
    }
}

extension Int8: DataType {
    public static var size: Int {
        MemoryLayout<Int8>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        self.init(Int8(b[0]))
    }
}

extension UInt16: DataType {
    public static var size: Int {
        MemoryLayout<UInt16>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        if order == .big {
            self.init(UInt16(b[1]) | UInt16(b[0])<<8)
        } else {
            self.init(UInt16(b[0]) | UInt16(b[1])<<8)
        }
    }
}

extension Int16: DataType {
    public static var size: Int {
        MemoryLayout<Int16>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        if order == .big {
            self.init(Int16(b[1]) | Int16(b[0])<<8)
        } else {
            self.init(Int16(b[0]) | Int16(b[1])<<8)
        }
    }
}

extension UInt32: DataType {
    public static var size: Int {
        MemoryLayout<UInt32>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        if order == .big {
            self.init(UInt32(b[3]) | UInt32(b[2])<<8 | UInt32(b[1])<<16 | UInt32(b[0])<<24)
        } else {
            self.init(UInt32(b[0]) | UInt32(b[1])<<8 | UInt32(b[2])<<16 | UInt32(b[3])<<24)
        }
    }
}

extension UInt: DataType {
    public static var size: Int {
        MemoryLayout<UInt>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        if order == .big {
            self.init(UInt(b[3]) | UInt(b[2])<<8 | UInt(b[1])<<16 | UInt(b[0])<<24)
        } else {
            self.init(UInt(b[0]) | UInt(b[1])<<8 | UInt(b[2])<<16 | UInt(b[3])<<24)
        }
    }
}

extension Int32: DataType {
    public static var size: Int {
        MemoryLayout<Int32>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        if order == .big {
            self.init(Int32(b[3]) | Int32(b[2])<<8 | Int32(b[1])<<16 | Int32(b[0])<<24)
        } else {
            self.init(Int32(b[0]) | Int32(b[1])<<8 | Int32(b[2])<<16 | Int32(b[3])<<24)
        }
    }
}

extension Int: DataType {
    public static var size: Int {
        MemoryLayout<Int>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        if order == .big {
            self.init(Int(b[3]) | Int(b[2])<<8 | Int(b[1])<<16 | Int(b[0])<<24)
        } else {
            self.init(Int(b[0]) | Int(b[1])<<8 | Int(b[2])<<16 | Int(b[3])<<24)
        }
    }
}

extension Float: DataType {
    public static var size: Int {
        MemoryLayout<Float>.size
    }
    
    public init(_ b: [UInt8], order: Endianness) {
        self.init(bitPattern: UInt32(b, order: order))
    }
}
