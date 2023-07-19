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
// MARK: * NBK x Flexible Width x Shifts x Unsigned x Storage
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

//extension NBKFlexibleWidth.Magnitude.Storage {
//
//    //=------------------------------------------------------------------------=
//    // MARK: Transformations x Int
//    //=------------------------------------------------------------------------=
//
//    @inlinable public mutating func bitshiftLeft(words: Int, atLeastOneBit bits: Int) {
//        precondition(words >= 0 && words < self.elements.count, NBK.callsiteOutOfBoundsInfo())
//        precondition(bits  >= 1 && bits  < UInt.bitWidth,       NBK.callsiteOutOfBoundsInfo())
//        //=--------------------------------------=
//        let push = UInt(bitPattern: bits)
//        let pull = UInt(bitPattern: UInt.bitWidth - bits)
//        //=--------------------------------------=
//        let offset: Int = ~(words)
//        var destination = self.elements.endIndex as Int
//        var word = self.elements[destination &+ offset]
//        //=--------------------------------------=
//        while destination > self.elements.startIndex {
//            self.elements.formIndex(before: &destination)
//            let pushed = word &<< push
//            word = destination > words ? self.elements[destination &+ offset] : UInt()
//            let pulled = word &>> pull
//            self.elements[destination] = pushed | pulled
//        }
//    }
//
//    @inlinable public mutating func bitshiftLeft(atLeastOneWord words: Int) {
//        precondition(words >= 1 && words < self.elements.count, NBK.callsiteOutOfBoundsInfo())
//        //=--------------------------------------=
//        for destination in self.elements.indices.reversed() {
//            self.elements[destination] = destination >= words ? self.elements[destination - words] : UInt()
//        }
//    }
//}
//
////=----------------------------------------------------------------------------=
//// MARK: + Right
////=----------------------------------------------------------------------------=
//
//extension NBKFlexibleWidth.Magnitude.Storage {
//
//    //=------------------------------------------------------------------------=
//    // MARK: Transformations x Int
//    //=------------------------------------------------------------------------=
//
//    @inlinable public mutating func bitshiftRight(words: Int, atLeastOneBit bits: Int) {
//        precondition(words >= 0 && words < self.elements.count, NBK.callsiteOutOfBoundsInfo())
//        precondition(bits  >= 1 && bits  < UInt.bitWidth,       NBK.callsiteOutOfBoundsInfo())
//        //=--------------------------------------=
//        let push = UInt(bitPattern: bits)
//        let pull = UInt(bitPattern: UInt.bitWidth - bits)
//        let sign = UInt(repeating: false)
//        //=--------------------------------------=
//        var destination = self.elements.startIndex
//        let edge = self.elements.distance(from: words, to: self.elements.endIndex)
//        var word = self.elements[words] as UInt
//        //=--------------------------------------=
//        while destination < edge {
//            let after  = self.elements.index(after: destination)
//            let pushed = word &>> push
//            word = after < edge ? self.elements[after &+ words] : sign
//            let pulled = word &<< pull
//            self.elements[destination] = pushed | pulled
//            destination = after
//        }
//    }
//
//    @inlinable public mutating func bitshiftRight(atLeastOneWord words: Int) {
//        precondition(words >= 1 && words < self.elements.count, NBK.callsiteOutOfBoundsInfo())
//        //=--------------------------------------=
//        let sign = UInt(repeating: false)
//        //=--------------------------------------=
//        let edge = self.elements.distance(from: words, to: self.elements.endIndex)
//        //=--------------------------------------=
//        for destination in self.elements.indices {
//            self.elements[destination] = destination < edge ? self.elements[destination + words] : sign
//        }
//    }
//}

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
// MARK: * NBK x Flexible Width x Shifts x Unsigned x Storage
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude.Storage {

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=

    @inlinable mutating func bitshiftLeft(words: Int, atLeastOneBit bits: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }

    @inlinable mutating func bitshiftLeft(atLeastOneWord words: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude.Storage {

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=

    @inlinable mutating func bitshiftRight(words: Int, atLeastOneBit bits: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }
    
    @inlinable mutating func bitshiftRight(atLeastOneWord words: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}
