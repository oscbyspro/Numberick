//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Double Width
//*============================================================================*

@frozen public struct NBKDoubleWidth<High>: NBKFixedWidthInteger,
CustomDebugStringConvertible, CustomStringConvertible,
MutableCollection, RandomAccessCollection where
High: NBKFixedWidthInteger, High.Digit: NBKCoreInteger<UInt> {
    
    /// The most significant part of this type.
    public typealias High = High
    
    /// The least significant part of this type.
    public typealias Low = High.Magnitude
    
    /// The digit of this type.
    public typealias Digit = High.Digit
    
    /// The magnitude of this type.
    public typealias Magnitude = NBKDoubleWidth<High.Magnitude>
    
    /// The bit pattern of this type.
    public typealias BitPattern = NBKDoubleWidth<High.Magnitude>
    
    /// An integer type with double the width of this type.
    public typealias DoubleWidth = NBKDoubleWidth<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        High.isSigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if _endian(big)
    /// The most  significant part of this value.
    public var high: High
    /// The least significant part of this value.
    public var low:  Low
    #else
    /// The least significant part of this value.
    public var low:  Low
    /// The most  significant part of this value.
    public var high: High
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(ascending  partition: LH<Low, High>) {
        self.low  = partition.low
        self.high = partition.high
    }
    
    @inlinable public init(descending partition: HL<High, Low>) {
        self.low  = partition.low
        self.high = partition.high
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Conditional Conformances
//*============================================================================*

extension NBKDoubleWidth:   NBKSignedInteger,   SignedInteger, SignedNumeric where High:   NBKSignedInteger { }
extension NBKDoubleWidth: NBKUnsignedInteger, UnsignedInteger  /*---------*/ where High: NBKUnsignedInteger { }

//*============================================================================*
// MARK: * NBK x Double Width x 128
//*============================================================================*

#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)

public typealias  Int128 = NBKDoubleWidth<NBKDoubleWidth< Int>>
public typealias UInt128 = NBKDoubleWidth<NBKDoubleWidth<UInt>>

#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x)

public typealias  Int128 = NBKDoubleWidth< Int>
public typealias UInt128 = NBKDoubleWidth<UInt>

#else

#error("DoubleWidthInteger can only be used on a 32-bit or 64-bit platform.")

#endif

//*============================================================================*
// MARK: * NBK x Double Width x 256
//*============================================================================*

public typealias  Int256 = NBKDoubleWidth< Int128>
public typealias UInt256 = NBKDoubleWidth<UInt128>

//*============================================================================*
// MARK: * NBK x Double Width x 512
//*============================================================================*

public typealias  Int512 = NBKDoubleWidth< Int256>
public typealias UInt512 = NBKDoubleWidth<UInt256>

//*============================================================================*
// MARK: * NBK x Double Width x 1024
//*============================================================================*

public typealias  Int1024 = NBKDoubleWidth< Int512>
public typealias UInt1024 = NBKDoubleWidth<UInt512>

//*============================================================================*
// MARK: * NBK x Double Width x 2048
//*============================================================================*

public typealias  Int2048 = NBKDoubleWidth< Int1024>
public typealias UInt2048 = NBKDoubleWidth<UInt1024>

//*============================================================================*
// MARK: * NBK x Double Width x 4096
//*============================================================================*

public typealias  Int4096 = NBKDoubleWidth< Int2048>
public typealias UInt4096 = NBKDoubleWidth<UInt2048>
