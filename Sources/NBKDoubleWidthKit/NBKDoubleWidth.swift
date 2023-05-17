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

/// A composable, large, fixed-width, two's complement, binary integer.
///
/// ``NBKDoubleWidth`` is a generic model for working with fixed-width integers larger
/// than 64 bits. Its bit width is double the bit width of its ``NBKDoubleWidth/High-swift.typealias``
/// component. In this way, you may construct any integer size that is a multiple of `UInt.bitWidth`.
///
/// ```swift
/// typealias  Int256 = NBKDoubleWidth< Int128>
/// typealias UInt256 = NBKDoubleWidth<UInt128>
/// ```
///
/// ### Trivial UInt Collection
///
/// ``NBKDoubleWidth`` models a trivial `UInt` collection. Its ``NBKDoubleWidth/High-swift.typealias``
/// component must therefore be trivial and a whole integer multiple of `UInt.bitWidth`. This layout
/// constraint makes it possible to operate on its words directly.
///
/// - Note: Integers with such layout conform to ``NBKMachineWordsInteger``.
///
/// ### Single Digit Arithmetic
///
/// Alongside ordinary arithmetic operations, ``NBKDoubleWidth`` also offers single digit operations,
/// where a digit is an un/signed machine word. These operations provide a more efficient alternative
/// for small calculations. See the following for more details:
///
/// - ``NBKBinaryInteger``
/// - ``NBKFixedWidthInteger``
///
/// - Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.
///
@frozen public struct NBKDoubleWidth<High>: NBKMachineWordsInteger,
CustomDebugStringConvertible, CustomStringConvertible,
MutableCollection, RandomAccessCollection
where High: NBKMachineWordsInteger, High.Digit: NBKCoreInteger<UInt> {
    
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
    
    @inlinable public init(ascending components: LH<Low, High>) {
        (self.low, self.high) = components
    }
    
    @inlinable public init(descending components: HL<High, Low>) {
        (self.high, self.low) = components
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var ascending: LH<Low, High> {
        LH(self.low, self.high)
    }
    
    @inlinable public var descending: HL<High, Low> {
        HL(self.high, self.low)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Conditional Conformances
//*============================================================================*

extension NBKDoubleWidth:
NBKSignedInteger, SignedInteger, SignedNumeric
where High: NBKSignedInteger { }

extension NBKDoubleWidth:
NBKUnsignedInteger, UnsignedInteger
where High: NBKUnsignedInteger { }

//*============================================================================*
// MARK: * NBK x Double Width x [U]128
//*============================================================================*

#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)

/// A 128-bit signed integer value type.
public typealias Int128 = NBKDoubleWidth<NBKDoubleWidth<Int>>

/// A 128-bit unsigned integer value type.
public typealias UInt128 = NBKDoubleWidth<NBKDoubleWidth<UInt>>

#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x)

/// A 128-bit signed integer value type.
public typealias Int128 = NBKDoubleWidth<Int>

/// A 128-bit unsigned integer value type.
public typealias UInt128 = NBKDoubleWidth<UInt>

#else

#error("NBKDoubleWidth can only be used on a 32-bit or 64-bit platform.")

#endif

//*============================================================================*
// MARK: * NBK x Double Width x [U]256
//*============================================================================*

/// A 256-bit signed integer value type.
public typealias Int256 = NBKDoubleWidth<Int128>

/// A 256-bit unsigned integer value type.
public typealias UInt256 = NBKDoubleWidth<UInt128>

//*============================================================================*
// MARK: * NBK x Double Width x [U]512
//*============================================================================*

/// A 512-bit signed integer value type.
public typealias Int512 = NBKDoubleWidth<Int256>

/// A 512-bit unsigned integer value type.
public typealias UInt512 = NBKDoubleWidth<UInt256>

//*============================================================================*
// MARK: * NBK x Double Width x [U]1024
//*============================================================================*

/// A 1024-bit signed integer value type.
public typealias Int1024 = NBKDoubleWidth<Int512>

/// A 1024-bit unsigned integer value type.
public typealias UInt1024 = NBKDoubleWidth<UInt512>

//*============================================================================*
// MARK: * NBK x Double Width x [U]2048
//*============================================================================*

/// A 2048-bit signed integer value type.
public typealias Int2048 = NBKDoubleWidth<Int1024>

/// A 2048-bit unsigned integer value type.
public typealias UInt2048 = NBKDoubleWidth<UInt1024>

//*============================================================================*
// MARK: * NBK x Double Width x [U]4096
//*============================================================================*

/// A 4096-bit signed integer value type.
public typealias Int4096 = NBKDoubleWidth<Int2048>

/// A 4096-bit unsigned integer value type.
public typealias UInt4096 = NBKDoubleWidth<UInt2048>
