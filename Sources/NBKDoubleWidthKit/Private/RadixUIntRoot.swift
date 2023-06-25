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
// MARK: * NBK x Radix UInt Root
//*============================================================================*

/// The largest exponent in `pow(radix, exponent) <= UInt.max + 1`.
///
/// - Its `base` is `>= 2` and `<= 36`
/// - Its `exponent` is `>= 1` and `<= UInt.bitWidth`
/// - A power of `UInt.max + 1` is represented by `0`
///
@usableFromInline protocol RadixUIntRoot {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @inlinable var base: UInt { get }
    
    @inlinable var exponent: UInt { get }
    
    @inlinable var power: UInt { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Divides `dividend` by the `base` of this solution.
    @inlinable func dividing(_ dividend: UInt) -> QR<UInt, UInt>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension RadixUIntRoot {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline var base: Int {
        assert((self.base as UInt) <= 36)
        return Int(bitPattern: self.base)
    }
    
    @_transparent @usableFromInline var exponent: Int {
        assert((self.exponent as UInt) <= UInt.bitWidth)
        return Int(bitPattern: self.exponent)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func dividing(_ dividend: UInt) -> QR<UInt, UInt> {
        dividend.quotientAndRemainder(dividingBy: self.base)
    }
}

//*============================================================================*
// MARK: * NBK x Radix UInt Root x Perfect
//*============================================================================*

/// A ``RadixUIntRoot`` with a power that is zero.
@frozen @usableFromInline struct PerfectRadixUIntRoot: RadixUIntRoot {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let root: AnyRadixUIntRoot
    @usableFromInline let special: QR<UInt, UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: AnyRadixUIntRoot) {
        assert(unchecked.power.isZero)
        assert([2, 4, 16].contains(unchecked.base))
        self.root = unchecked
        self.special.quotient  = UInt(bitPattern: self.root.base.trailingZeroBitCount)
        self.special.remainder = self.root.base &- 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline var base: UInt {
        self.root.base
    }
    
    @_transparent @usableFromInline var exponent: UInt {
        self.root.exponent
    }
    
    @_transparent @usableFromInline var power: UInt {
        self.root.power
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func dividing(_ dividend: UInt) -> QR<UInt, UInt> {
        QR(dividend &>> self.special.quotient, dividend & self.special.remainder)
    }
}

//*============================================================================*
// MARK: * NBK x Radix UInt Root x Imperfect
//*============================================================================*

/// A ``RadixUIntRoot`` with a power that is non-zero.
@frozen @usableFromInline struct ImperfectRadixUIntRoot: RadixUIntRoot {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let root: AnyRadixUIntRoot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: AnyRadixUIntRoot) {
        assert(!unchecked.power.isZero)
        assert(![2, 4, 16].contains(unchecked.base))
        self.root = unchecked
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline var base: UInt {
        self.root.base
    }
    
    @_transparent @usableFromInline var exponent: UInt {
        self.root.exponent
    }
    
    @_transparent @usableFromInline var power: UInt {
        self.root.power
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Overestimates how many times its power divides the magnitude.
    @inlinable func divisibilityByPowerUpperBound(_ magnitude: some UnsignedInteger) -> Int {
        magnitude.bitWidth / 36.leadingZeroBitCount &+ 1
    }
}

//*============================================================================*
// MARK: * NBK x Radix UInt Root x Any
//*============================================================================*

/// A ``RadixUIntRoot`` with a power that may be zero.
@frozen @usableFromInline struct AnyRadixUIntRoot: RadixUIntRoot {
    
    @usableFromInline typealias Solution = (exponent: UInt, power: UInt)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: UInt
    @usableFromInline let exponent: UInt
    @usableFromInline let power: UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given radix.
    ///
    /// The radix must not exceed `36` because that is the size of the alphabet.
    ///
    /// - Parameter radix: A value from `2` through `36`.
    ///
    @inlinable init(_ radix: Int) {
        Swift.precondition(2 ... 36 ~= radix)
        (self.base) = UInt(bitPattern: radix)
        (self.exponent, self.power) = Self.solution(unchecked: self.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the largest exponent in `pow(radix, exponent) <= UInt.max + 1`.
    @inlinable static func solution(unchecked radix: UInt) -> Solution {
        switch radix.isPowerOf2 {
        case  true: return Self.solutionAssumingRadixIsPowerOf2   (unchecked: radix)
        case false: return Self.solutionAssumingRadixIsNotPowerOf2(unchecked: radix) }
    }
    
    /// Returns the largest exponent in `pow(radix, exponent) <= UInt.max + 1`.
    @inlinable static func solutionAssumingRadixIsPowerOf2(unchecked radix: UInt) -> Solution {
        assert(radix >= 2)
        assert(radix.isPowerOf2)
        //=--------------------------------------=
        let zeros = UInt(bitPattern: radix.trailingZeroBitCount)
        //=--------------------------------------=
        // radix: 002, 004, 016, 256, ...
        //=--------------------------------------=
        if  zeros.isPowerOf2 {
            let exponent = UInt(bitPattern: UInt.bitWidth &>> zeros.trailingZeroBitCount)
            return Solution(exponent: exponent, power: 0)
        //=--------------------------------------=
        // radix: 008, 032, 064, 128, ...
        //=--------------------------------------=
        }   else {
            let exponent = UInt(bitPattern: UInt.bitWidth) / (zeros as UInt)
            return Solution(exponent: exponent, power: 1 &<< (zeros &* exponent))
        }
    }
    
    /// Returns the largest exponent in `pow(radix, exponent) <= UInt.max + 1`.
    @inlinable static func solutionAssumingRadixIsNotPowerOf2(unchecked radix: UInt) -> Solution {
        assert(radix >= 2)
        assert(radix.isPowerOf2 == false)
        //=--------------------------------------=
        // radix: 003, 005, 006, 007, ...
        //=--------------------------------------=
        let capacity: Int = UInt.bitWidth.trailingZeroBitCount - 1
        return Swift.withUnsafeTemporaryAllocation(of: Solution.self, capacity: capacity) { squares in
            //=----------------------------------=
            // de/init: pointee is trivial
            //=----------------------------------=
            var solution = Solution(1, radix)
            var index = squares.startIndex as Int
            
            loop: while index  < squares.endIndex {
                squares[index] = solution
                let product = solution.power.multipliedReportingOverflow(by: solution.power)
                if  product.overflow { break loop }
                
                solution.exponent &<<= 1 as UInt
                solution.power = product.partialValue
                squares.formIndex(after: &index)
            }
            
            loop: while index  > squares.startIndex {
                squares.formIndex(before: &index)
                let square  = squares[index]
                let product = solution.power.multipliedReportingOverflow(by: square.power)
                if  product.overflow { continue loop }
                
                solution.exponent &+= square.exponent
                solution.power = product.partialValue
            }
            
            return solution as Solution
        }
    }
}
