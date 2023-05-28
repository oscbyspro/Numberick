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
/// ### 🧩 Composable
///
/// ``NBKDoubleWidth`` is a generic software model for working with fixed-width
/// integers larger than one machine word. Its bit width is double the bit width of
/// its `High` component. In this way, you may construct new integer types:
///
/// ```swift
/// typealias  Int256 = NBKDoubleWidth< Int128>
/// typealias UInt256 = NBKDoubleWidth<UInt128>
/// ```
///
/// ### 💕 Two's Complement
///
/// Like other binary integers, ``NBKDoubleWidth`` has two's complement semantics.
///
/// ```
/// The two's complement representation of  0 is an infinite sequence of 0s.
/// The two's complement representation of -1 is an infinite sequence of 1s.
/// ```
///
/// ### 🏰 Fixed-Width Integer
///
///Each type of ``NBKDoubleWidth`` has a fixed bit width, and so do its halves.
///This design comes with a suite of overflow and bit-casting operations. The
///even split also lends itself to divide-and-conquer strategies. As such, it
///uses A. Karatsuba's multiplication algorithm, as well as C. Burnikel's and J.
///Ziegler's fast recursive division.
///
/// ### 📖 Trivial UInt Collection
///
/// ``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
/// unsigned machine word. It contains at least two words, and its word count
/// is always a power of two. This layout enables direct machine word access.
///
/// ```
/// // Int256 and UInt256, as constructed on a 64-bit platform:
/// ┌───────────────────────────┐ ┌───────────────────────────┐
/// │           Int256          │ │          UInt256          │
/// ├─────────────┬─────────────┤ ├─────────────┬─────────────┤
/// │    Int128   │   UInt128   │ │   UInt128   │   UInt128   │
/// ├──────┬──────┼──────┬──────┤ ├──────┬──────┼──────┬──────┤
/// │  Int │ UInt │ UInt │ UInt │ │ UInt │ UInt │ UInt │ UInt │
/// └──────┴──────┴──────┴──────┘ └──────┴──────┴──────┴──────┘
/// ```
///
/// Swift's type system enforces proper layout insofar as `Int` and `UInt` are the
/// only types in the standard library that meet its type requirements.
/// Specifically, only `Int` and `UInt` have `NBKCoreInteger<UInt>` `Digit` types.
///
/// ### 🚀 Single Digit Arithmetic
///
/// Alongside its ordinary arithmetic operations, ``NBKDoubleWidth`` also provides
/// single-digit operations, where a digit is an un/signed machine word. These
/// operations are more efficient for small calculations. Here are some examples:
///
/// ```swift
/// Int256(1) + Int(1) │ UInt256(1) + UInt(1)
/// Int256(2) - Int(2) │ UInt256(2) - UInt(2)
/// Int256(3) * Int(3) │ UInt256(3) * UInt(3)
/// Int256(4) / Int(4) │ UInt256(4) / UInt(4)
/// Int256(5) % Int(5) │ UInt256(5) % UInt(5)
/// ```
///
/// - Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.
///
@frozen public struct NBKDoubleWidth<High>:
NBKFixedWidthInteger, MutableCollection, RandomAccessCollection where
High: NBKFixedWidthInteger,  High.Digit: NBKCoreInteger<UInt> {
    
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
    
    /// Creates a new instance from the given partition.
    ///
    /// - Parameter ascending: An integer split into two parts, from least significant to most.
    ///
    @inlinable public init(ascending components: LH<Low, High>) {
        (self.low, self.high) = components
    }
    
    /// Creates a new instance from the given partition.
    ///
    /// - Parameter descending: An integer split into two parts, from most significant to least.
    ///
    @inlinable public init(descending components: HL<High, Low>) {
        (self.high, self.low) = components
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Conditional Conformances
//*============================================================================*

extension NBKDoubleWidth:   NBKSignedInteger,   SignedInteger, SignedNumeric where High:   NBKSignedInteger { }
extension NBKDoubleWidth: NBKUnsignedInteger, UnsignedInteger  /*---------*/ where High: NBKUnsignedInteger { }

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
