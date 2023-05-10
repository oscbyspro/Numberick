//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width Integer
//*============================================================================*

@frozen public struct DoubleWidthInteger<High>: FixedWidthInteger & WholeMachineWords
where High: FixedWidthInteger & WholeMachineWords, High.Magnitude:  WholeMachineWords {
    
    public typealias High = High
    
    public typealias Low  = High.Magnitude
    
    public typealias Magnitude = DoubleWidthInteger<High.Magnitude>
    
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
    
    @inlinable public init(high: High, low: Low) {
        self.low  = low
        self.high = high
    }
}

//*============================================================================*
// MARK: * NBK x Double Width Integer x Conditional Conformances
//*============================================================================*

extension DoubleWidthInteger:   SignedNumeric where High:   SignedInteger { }
extension DoubleWidthInteger:   SignedInteger where High:   SignedInteger { }
extension DoubleWidthInteger: UnsignedInteger where High: UnsignedInteger { }

//*============================================================================*
// MARK: * NBK x Double Width Integer x 128
//*============================================================================*

#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)

public typealias  Int128 = DoubleWidthInteger<DoubleWidthInteger< Int>>
public typealias UInt128 = DoubleWidthInteger<DoubleWidthInteger<UInt>>

#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x)

public typealias  Int128 = DoubleWidthInteger< Int>
public typealias UInt128 = DoubleWidthInteger<UInt>

#else

#error("DoubleWidthInteger can only be used on a 32-bit or 64-bit platform.")

#endif

//*============================================================================*
// MARK: * NBK x Double Width Integer x 256
//*============================================================================*

public typealias  Int256 = DoubleWidthInteger< Int128>
public typealias UInt256 = DoubleWidthInteger<UInt128>

//*============================================================================*
// MARK: * NBK x Double Width Integer x 512
//*============================================================================*

public typealias  Int512 = DoubleWidthInteger< Int256>
public typealias UInt512 = DoubleWidthInteger<UInt256>

//*============================================================================*
// MARK: * NBK x Double Width Integer x 1024
//*============================================================================*

public typealias  Int1024 = DoubleWidthInteger< Int512>
public typealias UInt1024 = DoubleWidthInteger<UInt512>

//*============================================================================*
// MARK: * NBK x Double Width Integer x 2048
//*============================================================================*

public typealias  Int2048 = DoubleWidthInteger< Int1024>
public typealias UInt2048 = DoubleWidthInteger<UInt1024>

//*============================================================================*
// MARK: * NBK x Double Width Integer x 4096
//*============================================================================*

public typealias  Int4096 = DoubleWidthInteger< Int2048>
public typealias UInt4096 = DoubleWidthInteger<UInt2048>
