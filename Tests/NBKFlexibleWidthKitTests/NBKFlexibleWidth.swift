//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Flexible Width x Initializers x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Limbs
    //=------------------------------------------------------------------------=
    
    init(x32 limbs: [UInt32]) {
        self.init(limbs: limbs)
    }
    
    init(x64 limbs: [UInt64]) {
        self.init(limbs: limbs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Limbs x Private
    //=------------------------------------------------------------------------=
    
    private init<Limb>(limbs: [Limb]) where Limb: NBKCoreInteger {
        switch Limb.bitWidth >= UInt.bitWidth {
        case  true: self.init(majorLimbs: limbs)
        case false: self.init(minorLimbs: limbs) }
    }
    
    private init<Limb>(majorLimbs: [Limb]) where Limb: NBKCoreInteger {
        precondition(Limb.bitWidth.isPowerOf2)
        precondition(Limb.bitWidth >= UInt.bitWidth)
        //=--------------------------------------=
        let ratio = Limb.bitWidth / UInt.bitWidth
        let count = majorLimbs.count * ratio
        var words = [UInt](); words.reserveCapacity(count)
        //=--------------------------------------=
        for limb in majorLimbs {
            words.append(contentsOf: limb.words)
        }
        //=--------------------------------------=
        self.init(words: words)
    }
    
    private init<Limb>(minorLimbs: [Limb]) where Limb: NBKCoreInteger {
        precondition(Limb.bitWidth.isPowerOf2)
        precondition(Limb.bitWidth <= UInt.bitWidth)
        //=--------------------------------------=
        let ratio = UInt.bitWidth / Limb.bitWidth
        let count = minorLimbs.count / ratio
        var words = [UInt](repeating: UInt.zero, count: count)
        //=--------------------------------------=
        var major = Int.zero
        var minor = Int.zero
        
        for limb in minorLimbs {
            words[major] |= UInt(truncatingIfNeeded: limb) &<< minor
            minor += Limb.bitWidth
            
            if  minor >= UInt.bitWidth {
                minor -= UInt.bitWidth
                major += 1
            }
        }
        //=--------------------------------------=
        self.init(words: words)
    }
}