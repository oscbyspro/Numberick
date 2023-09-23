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
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias RadixSolution = _NBKRadixSolution
    
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
public protocol _NBKRadixSolution<Size> {
    
    typealias Element  = Size.Magnitude
    
    associatedtype Size: NBKCoreInteger & NBKSignedInteger
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var base:     Element { get }
    
    @inlinable var exponent: Element { get }
    
    @inlinable var power:    Element { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var solution: NBK.AnyRadixSolution<Size> { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func division() -> (Element) -> QR<Element, Element>
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
}

//*============================================================================*
// MARK: * NBK x Radix Solution x Perfect
//*============================================================================*

/// A `RadixSolution` with a power that is zero.
@frozen public struct _NBKPerfectRadixSolution<Size>: NBK.RadixSolution where Size: NBKCoreInteger & NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let solution: NBK.AnyRadixSolution<Size>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ solution: NBK.AnyRadixSolution<Size>) {
        guard  solution.power.isZero else { return nil }
        Swift.assert([2, 4, 16].contains(solution.base))
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
    
    @inlinable public func division() -> (Element) -> QR<Element, Element> {
        Division(self).callAsFunction
    }
    
    //*========================================================================*
    // MARK: * Division
    //*========================================================================*
    
    @frozen @usableFromInline struct Division {
        
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
        
        @inlinable func callAsFunction(_ dividend: Element) -> QR<Element, Element> {
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
    
    public let solution: NBK.AnyRadixSolution<Size>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ solution: NBK.AnyRadixSolution<Size>) {
        guard !solution.power.isZero else { return nil }
        Swift.assert(![2, 4, 16].contains(solution.base))
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
    
    @inlinable public func division() -> (Element) -> QR<Element, Element> {
        Division(self).callAsFunction
    }
    
    /// Overestimates how many times its power divides the magnitude.
    @inlinable public func divisibilityByPowerUpperBound(_ magnitude: some UnsignedInteger) -> Int {
        magnitude.bitWidth / 36.leadingZeroBitCount &+ 1
    }
    
    //*========================================================================*
    // MARK: * Division
    //*========================================================================*
    
    @frozen @usableFromInline struct Division {
                
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
        
        @inlinable func callAsFunction(_ dividend: Element) -> QR<Element, Element> {
            dividend.quotientAndRemainder(dividingBy: self.base)
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
        case  true: (self.exponent, self.power) = Self.valueAssumingRadixIsAnyPowerOf2From2(self.base)
        case false: (self.exponent, self.power) = Self.valueAssumingRadixIsNonPowerOf2From2(self.base) }
    }
    
    @inlinable public init(_ other: some NBK.RadixSolution<Size>) {
        self = other.solution
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var solution: NBK.AnyRadixSolution<Size> { self }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func division() -> (Element) -> QR<Element, Element> {
        Division(self).callAsFunction
    }
    
    //*========================================================================*
    // MARK: * Division
    //*========================================================================*
    
    @frozen @usableFromInline struct Division {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let baseOrQuotientShift: Element
        @usableFromInline let zeroOrRemainderMask: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ solution: NBK.AnyRadixSolution<Size>) {
            if  solution.power.isZero {
                Swift.assert(solution.base.isPowerOf2)
                self.baseOrQuotientShift = NBK.initOrBitCast(truncating: solution.base.trailingZeroBitCount)
                self.zeroOrRemainderMask = solution.base &- (1 as Element)
            }   else {
                self.baseOrQuotientShift = solution.base
                self.zeroOrRemainderMask = 00 as Element
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func callAsFunction(_ dividend: Element) -> QR<Element, Element> {
            switch self.zeroOrRemainderMask.isZero {
            case  true: return QR(dividend.quotientAndRemainder(dividingBy:         self.baseOrQuotientShift) )
            case false: return QR(dividend &>> self.baseOrQuotientShift, dividend & self.zeroOrRemainderMask) }
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
    @inlinable static func valueAssumingRadixIsAnyPowerOf2From2(_ radix: Element) -> Value {
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
            value.power = (1 as Element) &<<  (zeros &* value.exponent)
        }
        
        return value as Value as Value as Value
    }
    
    /// Returns the largest exponent in `pow(radix, exponent) <= Element.max + 1`.
    @inlinable static func valueAssumingRadixIsNonPowerOf2From2(_ radix: Element) -> Value {
        assert(radix >= 2)
        assert(radix.isPowerOf2 == false)
        //=--------------------------------------=
        // radix: 003, 005, 006, 007, ...
        //=--------------------------------------=
        let capacity = Element.bitWidth.trailingZeroBitCount - 1
        return Swift.withUnsafeTemporaryAllocation(of: Value.self, capacity: capacity) { squares in
            let start = squares.baseAddress!
            var position = start as UnsafeMutablePointer<Value>
            var value = Value(1  as Element, radix)
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
            Swift.assert(position <= start.advanced(by: squares.count))
            loop: while  position >  start {
                position =  position.predecessor()
                let square  = position.move()
                let product = value.power.multipliedReportingOverflow(by: square.power)
                if  product.overflow { continue loop }
                
                value.exponent &+= square.exponent
                value.power = product.partialValue
            }
            
            return value as Value as Value as Value
        }
    }
}
