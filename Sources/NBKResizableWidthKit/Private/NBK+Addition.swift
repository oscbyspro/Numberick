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
// MARK: * NBK x Addition
//*============================================================================*

extension NBK {
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: T, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementAsUnsigned(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }

    @_transparent public static func incrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by addend: T, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementAsUnsigned(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: T, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.incrementAsUnsignedInIntersection(&limbs, by: addend, at: &index, carrying: &overflow)
        NBK.incrementAsUnsigned(&limbs, by: Void(), at: &index, carrying: &overflow)
    }
    
    @inlinable public static func incrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by addend: T, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        for addendIndex in addend.indices { // for-index-in >= for-element-in
            NBK.incrementAsUnsignedInIntersection(&limbs, by: addend[addendIndex], at: &index, carrying: &overflow)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Addition x Digit
//*============================================================================*

extension NBK {
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let (index, overflow) = NBK.incrementAsUnsignedInIntersection(&limbs, by: addend, at: index)
        return NBK.incrementAsUnsigned(&limbs, by: overflow, at: index) as IO
    }
    
    @_transparent public static func incrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let overflow = limbs[index].addReportingOverflow(addend)
        return IO(limbs.index(after: index), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
        
    @inlinable public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var overflow = NBK.incrementAsUnsignedInIntersection(&limbs, by: addend, at: &index)
        NBK.incrementAsUnsigned(&limbs, by: Void(), at: &index, carrying: &overflow)
        return overflow as Bool
    }
    
    @inlinable public static func incrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        defer{ limbs.formIndex(after: &index) }
        return limbs[index].addReportingOverflow(addend)
    }
}

//*============================================================================*
// MARK: * NBK x Addition x Digit x Carry
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: T.Element, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementAsUnsigned(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    @_transparent public static func incrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementAsUnsignedInIntersection(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.incrementAsUnsignedInIntersection(&limbs, by: addend, at: &index, carrying: &overflow)
        NBK.incrementAsUnsigned(&limbs, by: Void(), at: &index, carrying: &overflow)
    }
    
    @inlinable public static func incrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var addend: T.Element = addend
        
        if  overflow {
            overflow = addend.addReportingOverflow(1 as T.Element.Digit)
        }
        
        if !overflow {
            overflow = limbs[index].addReportingOverflow(addend)
        }
        
        limbs.formIndex(after: &index)
    }
}

//*============================================================================*
// MARK: * NBK x Addition x Bool
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = addend
        NBK.incrementAsUnsigned(&limbs, by: Void(), at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func incrementAsUnsigned<T>(
    _ limbs: inout T, by addend: Void, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        while overflow && index < limbs.endIndex {
            overflow = limbs[index].addReportingOverflow(1 as T.Element.Digit)
            limbs.formIndex(after: &index)
        }
    }
}
