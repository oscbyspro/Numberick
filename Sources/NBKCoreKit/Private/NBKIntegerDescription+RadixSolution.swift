//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Description x Radix Solution
//*============================================================================*

extension NBK.IntegerDescription {
    
    //*========================================================================*
    // MARK: * Perfect
    //*========================================================================*
    
    /// A `solution` with a power of zero.
    ///
    /// ### Solution
    ///
    /// The largest `exponent` and `power` in `pow(base, exponent) <= Element.max + 1`.
    ///
    /// - The `base` is `>= 2` and `<= 36`
    /// - The `exponent` is `>= 1` and `<= Element.bitWidth`
    /// - A power of `Element.max + 1` is represented by `0`
    ///
    @frozen public struct PerfectRadixSolution<Element> where Element: NBKCoreInteger & NBKUnsignedInteger {
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let solution: AnyRadixSolution<Element>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init?(_ solution: AnyRadixSolution<Element>) {
            guard  solution.power.isZero else { return nil }
            Swift.assert(solution.exponent.isPowerOf2)
            Swift.assert([2, 4, 16].contains(solution.base))
            self.solution = solution
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var base: Element {
            self.solution.base
        }
        
        @inlinable public var exponent: Element {
            self.solution.exponent
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func divisor() -> Divisor {
            Divisor(self)
        }
        
        //*====================================================================*
        // MARK: * Divisor
        //*====================================================================*
        
        @frozen public struct Divisor {
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline let quotientShift: Element
            @usableFromInline let remainderMask: Element
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(_ solution: PerfectRadixSolution<Element>) {
                self.quotientShift = NBK.initOrBitCast(truncating: solution.base.trailingZeroBitCount)
                self.remainderMask = solution.base &- (1 as Element)
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=
            
            @inlinable public func dividing(_ dividend: Element) -> QR<Element, Element> {
                QR(quotient: dividend &>> self.quotientShift, remainder: dividend & self.remainderMask)
            }
        }
    }
    
    //*========================================================================*
    // MARK: * Imperfect
    //*========================================================================*
    
    /// A `solution` with a non-zero power.
    ///
    /// ### Solution
    ///
    /// The largest `exponent` and `power` in `pow(base, exponent) <= Element.max + 1`.
    ///
    /// - The `base` is `>= 2` and `<= 36`
    /// - The `exponent` is `>= 1` and `<= Element.bitWidth`
    /// - A power of `Element.max + 1` is represented by `0`
    ///
    @frozen public struct ImperfectRadixSolution<Element> where Element: NBKCoreInteger & NBKUnsignedInteger {
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let solution: AnyRadixSolution<Element>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init?(_ solution: AnyRadixSolution<Element>) {
            guard !solution.power.isZero else { return nil }
            Swift.assert(![2, 4, 16].contains(solution.base))
            self.solution = solution
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var base: Element {
            self.solution.base
        }
        
        @inlinable public var exponent: Element {
            self.solution.exponent
        }
        
        @inlinable public var power: NBK.NonZero<Element> {
            NBK.NonZero(unchecked: self.solution.power)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func divisor() -> Divisor {
            Divisor(self)
        }
        
        @inlinable public func divisibilityByPowerUpperBound(magnitude: some Collection<UInt>) -> Int {
            magnitude.count * UInt.bitWidth / 36.leadingZeroBitCount &+ 1
        }
        
        //*====================================================================*
        // MARK: * Divisor
        //*====================================================================*
        
        @frozen public struct Divisor {
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline let base: Element
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(_ solution: ImperfectRadixSolution<Element>) {
                self.base = solution.base
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=
            
            @inlinable public func dividing(_ dividend: Element) -> QR<Element, Element> {
                dividend.quotientAndRemainder(dividingBy: self.base)
            }
        }
    }
    
    //*========================================================================*
    // MARK: * Any
    //*========================================================================*
    
    /// A `solution` with a power that may, or may not, be zero.
    ///
    /// ### Solution
    ///
    /// The largest `exponent` and `power` in `pow(base, exponent) <= Element.max + 1`.
    ///
    /// - The `base` is `>= 2` and `<= 36`
    /// - The `exponent` is `>= 1` and `<= Element.bitWidth`
    /// - A power of `Element.max + 1` is represented by `0`
    ///
    @frozen public struct AnyRadixSolution<Element> where Element: NBKCoreInteger & NBKUnsignedInteger {
        
        @usableFromInline typealias Exponentiation = (exponent: Element, power: Element)
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let base:     Element
        public let exponent: Element
        public let power:    Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ other: PerfectRadixSolution<Element>) {
            self = other.solution
        }
        
        @inlinable public init(_ other: ImperfectRadixSolution<Element>) {
            self = other.solution
        }
        
        /// Creates a new instance from the given radix.
        ///
        /// The radix must not exceed `36` because that is the size of the alphabet.
        ///
        /// - Parameter radix: A value from `2` through `36`.
        ///
        @inlinable public init(_ radix: Int) {
            precondition(2 ... 36 ~=  radix)
            (self.base) = NBK.initOrBitCast(truncating: radix) // <= 36
            (self.exponent, self.power) = NBK.PowerOf2.switch(self.base,
            true: Self.exponentiate, false: Self.exponentiate)
        }

        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Exponentiates `base` through `Element.max + 1`.
        ///
        /// - Parameter base: Any power of 2 greater than 1.
        ///
        /// - Returns: The `exponent` and `power` where `0` represents `Element.max + 1`.
        ///
        @inlinable static func exponentiate(_ base: NBK.PowerOf2<Element>) -> Exponentiation {
            precondition(base.value > 1)
            //=----------------------------------=
            let exponentiation:  Exponentiation
            let zeros: Element = NBK.initOrBitCast(truncating: base.value.trailingZeroBitCount)
            //=----------------------------------=
            // radix: 002, 004, 016, 256, ...
            //=----------------------------------=
            if  zeros.isPowerOf2 {
                exponentiation.exponent = NBK.initOrBitCast(truncating: Element.bitWidth &>> zeros.trailingZeroBitCount)
                exponentiation.power = (0 as Element)
            //=----------------------------------=
            // radix: 008, 032, 064, 128, ...
            //=----------------------------------=
            }   else {
                exponentiation.exponent = NBK.initOrBitCast(truncating: Element.bitWidth) / (zeros)
                exponentiation.power = (1 as Element)  &<< (zeros &* exponentiation.exponent)
            }
            //=----------------------------------=
            return exponentiation as Exponentiation
        }
        
        /// Exponentiates `base` through `Element.max + 1`.
        ///
        /// - Parameter base: Any non-power of 2 greater than 1.
        ///
        /// - Returns: The `exponent` and `power` where `0` represents `Element.max + 1`.
        ///
        /// - Note: The power returned by this method is non-zero.
        ///
        @inlinable static func exponentiate(_ base: NBK.NonPowerOf2<Element>) -> Exponentiation {
            precondition(base.value > 1)
            //=----------------------------------=
            // radix: 003, 005, 006, 007, ...
            //=----------------------------------=
            let capacity: Int = Element.bitWidth.trailingZeroBitCount - 1
            return Swift.withUnsafeTemporaryAllocation(of: Exponentiation.self, capacity: capacity) {
                let squares = NBK.unwrapping($0)!
                var pointer = squares.baseAddress
                var current = Exponentiation(1, base.value)
                //=------------------------------=
                // pointee: initialization
                //=------------------------------=
                loop: while true {
                    pointer.initialize(to: current)

                    let product = current.power.multipliedReportingOverflow(by: current.power)
                    if  product.overflow { break loop }
                    
                    current.exponent &<<= 1 as Element
                    current.power = product.partialValue
                    pointer = pointer.successor()
                }
                //=------------------------------=
                // pointee: move deinitialization
                //=------------------------------=
                Swift.assert(squares.baseAddress.distance(to: pointer) <= squares.count)
                loop: while   pointer > squares.baseAddress {
                    pointer = pointer.predecessor()
                    
                    let square  = pointer.move()
                    let product = current.power.multipliedReportingOverflow(by: square.power)
                    if  product.overflow { continue loop }
                    
                    current.exponent &+= square.exponent
                    current.power = product.partialValue
                }
                //=------------------------------=
                return current as Exponentiation
            }
        }
    }
}
