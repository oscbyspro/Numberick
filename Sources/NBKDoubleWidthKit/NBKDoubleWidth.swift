//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !COCOAPODS
import NBKCoreKit
#endif

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
/// Each type of ``NBKDoubleWidth`` has a fixed bit width, and so do its halves.
/// This design comes with a suite of overflow and bit-casting operations. The
/// even split also lends itself to divide-and-conquer strategies. As such, it
/// leverages A. Karatsuba's multiplication algorithm, as well as C. Burnikel's
/// and J. Ziegler's fast recursive division.
///
/// ### 📖 Trivial UInt Collection
///
/// ``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
/// unsigned machine word. It contains at least two words, but the exact count
/// depends on the platform's architecture. You should, therefore, use
/// properties like `startIndex` and `endIndex` instead of hard-coded indices.
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
/// ### 🚀 Single Digit Arithmagick
///
/// Alongside its ordinary arithmagick operations, ``NBKDoubleWidth`` provides
/// single-digit operations, where a digit is an un/signed machine word. These
/// operations are more efficient for small calculations. Here are some examples:
///
/// ```swift
/// Int256(1) + Int(1), UInt256(1) + UInt(1)
/// Int256(2) - Int(2), UInt256(2) - UInt(2)
/// Int256(3) * Int(3), UInt256(3) * UInt(3)
/// Int256(4) / Int(4), UInt256(4) / UInt(4)
/// Int256(5) % Int(5), UInt256(5) % UInt(5)
/// ```
///
/// - Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.
///
@frozen public struct NBKDoubleWidth<High>:
NBKFixedWidthInteger, MutableCollection, RandomAccessCollection where
High: NBKFixedWidthInteger,  High.Digit: NBKCoreInteger<UInt> {
    
    /// The most  significant half of this type.
    public typealias High = High
    
    /// The least significant half of this type.
    public typealias Low = High.Magnitude
    
    /// The digit of this type.
    public typealias Digit = High.Digit
    
    /// The magnitude of this type.
    public typealias Magnitude = NBKDoubleWidth<High.Magnitude>
    
    /// The bit pattern of this type.
    public typealias BitPattern = NBKDoubleWidth<High.Magnitude>
    
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
    /// The most  significant half of this value.
    public var high: High
    /// The least significant half of this value.
    public var low:  Low
    #else
    /// The least significant half of this value.
    public var low:  Low
    /// The most  significant half of this value.
    public var high: High
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Halves
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `low` half.
    ///
    /// - Parameter low:  The least significant half of this value.
    ///
    @inlinable public init(low: Low) {
        self.init(low: low, high: High.zero)
    }
    
    /// Creates a new instance from the given `low` and `high` halves.
    ///
    /// - Parameter low:  The least significant half of this value.
    /// - Parameter high: The most  significant half of this value.
    ///
    @inlinable public init(low: Low, high: High) {
        self.init(ascending: LH(low: low,  high: high))
    }
    
    /// Creates a new instance from the given `low` and `high` halves.
    ///
    /// - Parameter ascending: Both halves of this value, from least significant to most.
    ///
    @inlinable public init(ascending halves: LH<Low, High>) {
        (self.low, self.high) = halves
    }
    
    /// Creates a new instance from the given `high` half.
    ///
    /// - Parameter high: The most  significant half of this value.
    ///
    @inlinable public init(high: High) {
        self.init(high: high, low: Low.zero)
    }
    
    /// Creates a new instance from the given `high` and `low` halves.
    ///
    /// - Parameter high: The most  significant half of this value.
    /// - Parameter low:  The least significant half of this value.
    ///
    @inlinable public init(high: High, low:  Low) {
        self.init(descending: HL(high: high, low: low))
    }
    
    /// Creates a new instance from the given `high` and `low` halves.
    ///
    /// - Parameter descending: Both halves of this value, from most significant to least.
    ///
    @inlinable public init(descending halves: HL<High, Low>) {
        (self.high, self.low) = halves
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors x Halves
    //=------------------------------------------------------------------------=
    
    /// The `low` and `high` halves of this value.
    @inlinable public var ascending: LH<Low, High> {
        get { (low: self.low, high: self.high) }
        set { (self.low, self.high) = newValue }
    }
    
    /// The `high` and `low` halves of this value.
    @inlinable public var descending: HL<High, Low> {
        get { (high: self.high, low: self.low) }
        set { (self.high, self.low) = newValue }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A `description` of this type.
    ///
    /// ```
    /// ┌──────────────────────── → ────────────┐
    /// │ type                    │ description │
    /// ├──────────────────────── → ────────────┤
    /// │ NBKDoubleWidth< Int128> │  "Int256"   │
    /// │ NBKDoubleWidth<UInt256> │ "UInt512"   │
    /// └──────────────────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        let signedness = Self.isSigned ? "" : "U"
        return "\(signedness)Int\(Self.bitWidth)"
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

/// A signed, 128-bit, integer.
public typealias Int128 = NBKDoubleWidth<NBKDoubleWidth<Int>>

/// An unsigned, 128-bit, integer.
public typealias UInt128 = NBKDoubleWidth<NBKDoubleWidth<UInt>>

#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x)

/// A signed, 128-bit, integer.
public typealias Int128 = NBKDoubleWidth<Int>

/// An unsigned, 128-bit, integer.
public typealias UInt128 = NBKDoubleWidth<UInt>

#else

#error("NBKDoubleWidth can only be used on a 32-bit or 64-bit platform.")

#endif

//*============================================================================*
// MARK: * NBK x Double Width x [U]256
//*============================================================================*

/// A signed, 256-bit, integer.
public typealias Int256 = NBKDoubleWidth<Int128>

/// An unsigned, 256-bit, integer.
public typealias UInt256 = NBKDoubleWidth<UInt128>

//*============================================================================*
// MARK: * NBK x Double Width x [U]512
//*============================================================================*

/// A signed, 512-bit, integer.
public typealias Int512 = NBKDoubleWidth<Int256>

/// An unsigned, 512-bit, integer.
public typealias UInt512 = NBKDoubleWidth<UInt256>

//*============================================================================*
// MARK: * NBK x Double Width x [U]1024
//*============================================================================*

/// A signed, 1024-bit, integer.
public typealias Int1024 = NBKDoubleWidth<Int512>

/// An unsigned, 1024-bit, integer.
public typealias UInt1024 = NBKDoubleWidth<UInt512>

//*============================================================================*
// MARK: * NBK x Double Width x [U]2048
//*============================================================================*

/// A signed, 2048-bit, integer.
public typealias Int2048 = NBKDoubleWidth<Int1024>

/// An unsigned, 2048-bit, integer.
public typealias UInt2048 = NBKDoubleWidth<UInt1024>

//*============================================================================*
// MARK: * NBK x Double Width x [U]4096
//*============================================================================*

/// A signed, 4096-bit, integer.
public typealias Int4096 = NBKDoubleWidth<Int2048>

/// An unsigned, 4096-bit, integer.
public typealias UInt4096 = NBKDoubleWidth<UInt2048>
