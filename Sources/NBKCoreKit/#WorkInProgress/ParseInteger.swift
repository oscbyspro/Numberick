//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x ???
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func parseCoreInteger<T>(ascii text: some StringProtocol, radix: Int) -> T? where T: NBKFixedWidthInteger {
        var text = String(text); return text.withUTF8({ NBK.parseCoreInteger(ascii: $0, radix: radix) })
    }
    
    @inlinable public static func parseCoreInteger<T>(ascii: UnsafeBufferPointer<UInt8>, radix: Int) -> T? where T: NBKFixedWidthInteger {
        guard let first = ascii.first else { return nil }
        //=------------------------------------------=
        let _plus  = 43 as UInt8
        let _minus = 45 as UInt8
        //=------------------------------------------=
        if  first == _minus {
            return NBK.parseCoreIntegerDigits(ascii: UnsafeBufferPointer(rebasing: ascii[1...]), radix: radix, minus: true)
        }
        
        if  first == _plus {
            return NBK.parseCoreIntegerDigits(ascii: UnsafeBufferPointer(rebasing: ascii[1...]), radix: radix, minus: false)
        }
        //=------------------------------------------=
        return NBK.parseCoreIntegerDigits(ascii: ascii, radix: radix, minus: false)
    }
    
    @inlinable public static func parseCoreIntegerDigits<T>(ascii: UnsafeBufferPointer<UInt8>, radix: Int, minus: Bool) -> T? where T: NBKFixedWidthInteger {
        precondition(radix >= 2 && radix <= 36)
        //=------------------------------------------=
        guard !ascii.isEmpty else { return nil }
        //=------------------------------------------=
        let _0 = 48 as UInt8
        let _A = 65 as UInt8
        let _a = 97 as UInt8
        //=------------------------------------------=
        let numericalUpperBound: UInt8
        let uppercaseUpperBound: UInt8
        let lowercaseUpperBound: UInt8
        //=------------------------------------------=
        if  radix <= 10 {
            numericalUpperBound = _0 &+ UInt8(truncatingIfNeeded: radix)
            uppercaseUpperBound = _A
            lowercaseUpperBound = _a
        }   else {
            numericalUpperBound = _0 &+ 10
            uppercaseUpperBound = _A &+ UInt8(truncatingIfNeeded: radix &- 10)
            lowercaseUpperBound = _a &+ UInt8(truncatingIfNeeded: radix &- 10)
        }
        //=------------------------------------------=
        var result = 0 as T
        let multiplicand = T(truncatingIfNeeded: radix)
        
        for digit in ascii {
            let value: T
            
            if  digit >= _0 && digit < numericalUpperBound {
                value = T(truncatingIfNeeded: digit &- _0)
            }   else if digit >= _A && digit < uppercaseUpperBound {
                value = T(truncatingIfNeeded: digit &- _A &+ 10)
            }   else if digit >= _a && digit < lowercaseUpperBound {
                value = T(truncatingIfNeeded: digit &- _a &+ 10)
            }   else {
                return nil
            }
            
            guard !result.multiplyReportingOverflow(by: multiplicand) else { return nil }
            guard minus ? !result.subtractReportingOverflow(value) : !result.addReportingOverflow(value) else { return nil }
        }
        
        return result
    }
}
