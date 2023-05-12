//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Signed
//*============================================================================*

/// A decorative, width agnostic, sign-and-magnitude, numeric integer.
///
/// ```swift
/// typealias Magnitude = UInt
/// let min = Signed(Magnitude.max, as: Sign.minus)
/// let max = Signed(Magnitude.max, as: Sign.plus )
/// ```
///
/// ### Sign & Magnitude
///
/// ``NBKSigned`` models a sign and a magnitude that are independent of each other,
/// meaning that the sign is unaffected by fixed-width integer overflow. The following
/// illustrates its behavior:
///
/// ```swift
/// Signed<UInt8>(255, as: .minus) &- 1 // Signed<UInt8>(0, as: .minus)
/// Signed<UInt8>(255, as: .plus ) &+ 1 // Signed<UInt8>(0, as: .plus )
/// ```
///
/// ### Positive Zero & Negative Zero
///
/// Zero is signed, meaning that it can be either positive or negative. These values
/// are comparatively equal and have the same `hashValue`. This makes it possible to
/// ``NBKSign/toggle()`` the sign without checking for zero.
///
/// - use ``isLessThanZero`` to check if a value is `negative` and non-zero
/// - use ``isMoreThanZero`` to check if a value is `positive` and non-zero
///
/// ### Single Digit Arithmetic
///
/// Alongside its ordinary arithmetic operations, ``NBKSigned`` also offers single digit
/// operations. These methods are more efficient, but they can only be used on operands that
/// fit in a machine word. See the following for more details:
///
/// - ``NBKBinaryInteger``
/// - ``NBKFixedWidthInteger``
///
/// - Note: The `Digit` type is `NBKSigned<Magnitude.Digit>`.
///
@frozen public struct NBKSigned<Magnitude>: Comparable, Hashable, Sendable where Magnitude: NBKUnsignedInteger {
    
    /// The magnitude of this type.
    public typealias Magnitude = Magnitude
    
    /// The digit of this type.
    public typealias Digit = NBKSigned<Magnitude.Digit>

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The positive zero value.
    ///
    /// Positive and negative zero are equal and have the same `hashValue`.
    ///
    @inlinable public static var zero: Self {
        Self()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The sign of this value.
    public var sign: NBKSign
    
    /// The magnitude of this value.
    public var magnitude: Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with a positive zero value.
    @inlinable public init() {
        self.init(Magnitude(), as: NBKSign.plus)
    }
    
    /// Creates a new instance with the given sign and magnitude.
    @inlinable public init(_ magnitude: Magnitude, as sign: NBKSign) {
        self.sign = sign
        self.magnitude = magnitude
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    /// Returns `true` for all values except negative zero where it returns `false`.
    @inlinable public var isNormal: Bool {
        self.sign == NBKSign.plus || !self.isZero
    }
    
    /// Returns the ``NBKSigned/sign`` when ``NBKSigned/isNormal``, and ``NBKSign/plus`` otherwise.
    @inlinable public var normalizedSign: NBKSign {
        self.isNormal ? self.sign : NBKSign.plus
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Comparisons
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Returns `1` if this value is positive, `-1` if it is negative, and `0` otherwise.
    @inlinable public func signum() -> Int {
        self.isZero ? 0 : self.sign == NBKSign.plus ? 1 : -1
    }
    
    /// Returns whether this value is equal to zero.
    @_transparent public var isZero: Bool {
        self.magnitude.isZero
    }
    
    /// Returns whether this value is less than zero.
    @inlinable public var isLessThanZero: Bool {
        self.sign != NBKSign.plus && !self.isZero
    }
    
    /// Returns whether this value is more than zero.
    @inlinable public var isMoreThanZero: Bool {
        self.sign == NBKSign.plus && !self.isZero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        //=--------------------------------------=
        if  lhs.sign != rhs.sign {
            return lhs.isZero && rhs.isZero
        }
        //=--------------------------------------=
        return lhs.magnitude == rhs.magnitude
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        //=--------------------------------------=
        if  lhs.sign != rhs.sign {
            return (lhs.sign != NBKSign.plus) && !(lhs.isZero && rhs.isZero)
        }
        //=--------------------------------------=
        return lhs.sign == NBKSign.plus
        ? lhs.magnitude < rhs.magnitude
        : rhs.magnitude < lhs.magnitude
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.magnitude)
        hasher.combine(self.normalizedSign)
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        //=--------------------------------------=
        if  self.sign != other.sign {
            if self.isZero && other.isZero { return 0 }
            return self.sign == NBKSign.plus ? 1 : -1
        }
        //=--------------------------------------=
        let m = self.magnitude.compared(to: other.magnitude)
        return  self.sign == NBKSign.plus ? m : -(m)
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Fixed Width
//*============================================================================*

extension NBKSigned where Magnitude: FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The minimum representable value in this type.
    @inlinable public static var min: Self {
        Self(Magnitude.max, as: NBKSign.minus)
    }
    
    /// The maximum representable value in this type.
    @inlinable public static var max: Self {
        Self(Magnitude.max, as: NBKSign.plus)
    }
}
