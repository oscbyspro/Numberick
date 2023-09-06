//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Radix Solution
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Protocols
    //=------------------------------------------------------------------------=
    
    public typealias RadixSolution = _NBKRadixSolution
    
    public typealias RadixSolutionDivisor = _NBKRadixSolutionDivisor
    
    //=------------------------------------------------------------------------=
    // MARK: Models
    //=------------------------------------------------------------------------=
    
    public typealias AnyRadixSolution = _NBKAnyRadixSolution
    
    public typealias PerfectRadixSolution = _NBKPerfectRadixSolution
    
    public typealias ImperfectRadixSolution = _NBKImperfectRadixSolution
}

//*============================================================================*
// MARK: * NBK x Radix Solution
//*============================================================================*

/// Max power and exponent in `pow(base, exponent) <= Element.max + 1`.
///
/// - The `base` is `>= 2` and `<= 36`
/// - The `exponent` is `>= 1` and `<= Element.bitWidth`
/// - A power of `Element.max + 1` is represented by `0`
///
public protocol _NBKRadixSolution {
    
    typealias Element = Size.Magnitude
    
    associatedtype Size: NBKCoreInteger & NBKSignedInteger
    
    associatedtype Divisor: NBK.RadixSolutionDivisor where Divisor.Size == Size
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @inlinable var base: Element { get }
    
    @inlinable var exponent: Element { get }
    
    @inlinable var power: Element { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func divisor() -> Divisor
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBK.RadixSolution {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var base: Size {
        assert((self.base as Element) <= 36)
        return Size(bitPattern: self.base)
    }
    
    @inlinable public var exponent: Size {
        assert((self.exponent as Element) <= Element.bitWidth)
        return Size(bitPattern: self.exponent)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func dividing(_ dividend: Element) -> QR<Element, Element> {
        self.divisor().dividing(dividend)
    }
}

//*============================================================================*
// MARK: * NBK x Radix Solution x Divisor
//*============================================================================*

/// An radix solution helper model allowing efficient repeated division.
public protocol _NBKRadixSolutionDivisor<Size> where Size: NBKCoreInteger & NBKSignedInteger {
    
    typealias Element = Size.Magnitude
    
    associatedtype Size: NBKCoreInteger & NBKSignedInteger
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` of dividing `dividend` by `self`.
    @inlinable func dividing(_ dividend: Element) -> QR<Element, Element>
}

//*============================================================================*
// MARK: * NBK x Radix Solution x Perfect
//*============================================================================*

/// A `RadixSolution` with a power that is zero.
@frozen public struct _NBKPerfectRadixSolution<Size>: NBK.RadixSolution where Size: NBKCoreInteger & NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let solution: NBK.AnyRadixSolution<Size>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ solution: NBK.AnyRadixSolution<Size>) {
        guard  solution.power.isZero else { return nil }
        assert(solution.power.isZero)
        assert([2, 4, 16].contains(solution.base))
        self.solution = solution
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var base: Element {
        self.solution.base
    }
    
    @inlinable public var exponent: Element {
        self.solution.exponent
    }
    
    @inlinable public var power: Element {
        self.solution.power
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func divisor() -> Divisor {
        Divisor(self)
    }
    
    //*========================================================================*
    // MARK: * Divisor
    //*========================================================================*
    
    @frozen public struct Divisor: NBK.RadixSolutionDivisor {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let quotientShift: Element
        @usableFromInline let remainderMask: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ solution: NBK.PerfectRadixSolution<Size>) {
            self.quotientShift = NBK.initOrBitCast(truncating: solution.base.trailingZeroBitCount)
            self.remainderMask = solution.base &- (1 as Element)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func dividing(_ dividend: Element) -> QR<Element, Element> {
            QR(dividend &>> self.quotientShift, dividend & self.remainderMask)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Radix Solution x Imperfect
//*============================================================================*

/// A `RadixSolution` with a power that is non-zero.
@frozen public struct _NBKImperfectRadixSolution<Size>: NBK.RadixSolution where Size: NBKCoreInteger & NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let solution: NBK.AnyRadixSolution<Size>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ solution: NBK.AnyRadixSolution<Size>) {
        guard  !solution.power.isZero else { return nil }
        assert(!solution.power.isZero)
        assert(![2, 4, 16].contains(solution.base))
        self.solution = solution
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var base: Element {
        self.solution.base
    }
    
    @inlinable public var exponent: Element {
        self.solution.exponent
    }
    
    @inlinable public var power: Element {
        self.solution.power
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func divisor() -> Divisor {
        Divisor(self)
    }
    
    /// Overestimates how many times its power divides the magnitude.
    @inlinable public func divisibilityByPowerUpperBound(_ magnitude: some UnsignedInteger) -> Int {
        magnitude.bitWidth / 36.leadingZeroBitCount &+ 1
    }
    
    //*========================================================================*
    // MARK: * Divisor
    //*========================================================================*
    
    @frozen public struct Divisor: NBK.RadixSolutionDivisor {
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ solution: NBK.ImperfectRadixSolution<Size>) {
            self.base = solution.base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func dividing(_ dividend: Element) -> QR<Element, Element> {
            QR(dividend.quotientAndRemainder(dividingBy: self.base))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Radix Solution x Any
//*============================================================================*

@frozen public struct _NBKAnyRadixSolution<Size>: NBK.RadixSolution where Size: NBKCoreInteger & NBKSignedInteger {
    
    @usableFromInline typealias Value = (exponent: Element, power: Element)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base:     Element
    public let exponent: Element
    public let power:    Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given radix.
    ///
    /// The radix must not exceed `36` because that is the size of the alphabet.
    ///
    /// - Parameter radix: A value from `2` through `36`.
    ///
    @inlinable public init(_ radix: Int) {
        precondition(2 ... 36 ~=  radix)
        //=--------------------------------------=
        self.base = NBK.initOrBitCast(truncating: radix)
        // all core integers can represent the range 2 ... 36
        
        switch radix.isPowerOf2 {
        case  true: (self.exponent, self.power) = Self.valueAssumingRadixIsPowerOf2(self.base)
        case false: (self.exponent, self.power) = Self.valueAssumingRadixIsNotPowerOf2(self.base) }
    }
    
    @inlinable public init(_ radix: NBK.PerfectRadixSolution<Size>) {
        self = radix.solution
    }
    
    @inlinable public init(_ radix: NBK.ImperfectRadixSolution<Size>) {
        self = radix.solution
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func divisor() -> Divisor {
        Divisor(self)
    }
    
    //*========================================================================*
    // MARK: * Divisor
    //*========================================================================*
    
    @frozen public struct Divisor: NBK.RadixSolutionDivisor {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let baseOrQuotientShift: Element
        @usableFromInline let zeroOrRemainderMask: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ solution: _NBKAnyRadixSolution<Size>) {
            assert(solution.base >= 2)
            if  solution.power.isZero {
                self.baseOrQuotientShift = NBK.initOrBitCast(truncating: solution.base.trailingZeroBitCount)
                self.zeroOrRemainderMask = solution.base &+ Element.max // &- 1
            }   else {
                self.baseOrQuotientShift = solution.base
                self.zeroOrRemainderMask = 00000 as Element
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func dividing(_ dividend: Element) -> QR<Element, Element> {
            switch self.zeroOrRemainderMask.isZero {
            case  true: return QR(dividend.quotientAndRemainder(dividingBy:    self.baseOrQuotientShift) )
            case false: return QR(dividend &>> baseOrQuotientShift, dividend & self.zeroOrRemainderMask) }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension _NBKAnyRadixSolution {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the largest exponent in `pow(radix, exponent) <= Element.max + 1`.
    @inlinable static func valueAssumingRadixIsPowerOf2(_ radix: Element) -> Value {
        assert(radix >= 2)
        assert(radix.isPowerOf2)
        //=--------------------------------------=
        let value: Value
        let zeros: Element = NBK.initOrBitCast(truncating: radix.trailingZeroBitCount)
        //=--------------------------------------=
        // radix: 002, 004, 016, 256, ...
        //=--------------------------------------=
        if  zeros.isPowerOf2 {
            value.exponent = NBK.initOrBitCast(truncating: Element.bitWidth &>> zeros.trailingZeroBitCount)
            value.power = (0 as Element)
        //=--------------------------------------=
        // radix: 008, 032, 064, 128, ...
        //=--------------------------------------=
        }   else {
            value.exponent = NBK.initOrBitCast(truncating: Element.bitWidth) / (zeros)
            value.power = (1 as Element) &<< (zeros &* value.exponent)
        }
        
        return value as Value
    }
    
    /// Returns the largest exponent in `pow(radix, exponent) <= Element.max + 1`.
    @inlinable static func valueAssumingRadixIsNotPowerOf2(_ radix: Element) -> Value {
        assert(radix >= 2)
        assert(radix.isPowerOf2 == false)
        //=--------------------------------------=
        // radix: 003, 005, 006, 007, ...
        //=--------------------------------------=
        let capacity: Int = Element.bitWidth.trailingZeroBitCount - 1
        return Swift.withUnsafeTemporaryAllocation(of: Value.self, capacity: capacity) { squares in
            let start = squares.baseAddress!
            var position = start as UnsafeMutablePointer<Value>
            var value = Value(exponent: 1, power: radix)
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            loop: while true {
                position.initialize(to: value)
                let product = value.power.multipliedReportingOverflow(by: value.power)
                if  product.overflow { break loop }
                
                value.exponent &<<= 1 as Element
                value.power = product.partialValue
                position = position.successor()
            }
            //=----------------------------------=
            // pointee: deinitialization by move
            //=----------------------------------=
            assert(position <= start.advanced(by: squares.count))
            loop: while position > start {
                position = position.predecessor()
                let square  = position.move()
                let product = value.power.multipliedReportingOverflow(by: square.power)
                if  product.overflow { continue loop }
                
                value.exponent &+= square.exponent
                value.power = product.partialValue
            }
            
            return value as Value
        }
    }
}
