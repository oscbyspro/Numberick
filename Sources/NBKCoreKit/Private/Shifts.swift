//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Shifts x Limbs
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Left
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift on a least-to-most-significant limb collection.
    ///
    /// - Parameters:
    ///   - pointee: The mutable collection.
    ///   - environment: The bit used to fill the void.
    ///   - limbs: `0 <= limbs < pointee.count`
    ///   - bits:  `1 <= bits  < Limb.bitWidth`
    ///
    @inline(__always) @inlinable public static func bitshiftLeftAsFixedLimbsCodeBlock<T>(
    _ pointee: inout T, environment: Bool, limbs: Int, atLeastOneBit bits: Int)
    where T: RandomAccessCollection & MutableCollection, T.Element: NBKCoreInteger & UnsignedInteger, T.Indices == Range<Int> {
        typealias Limb = T.Element
        precondition(0 ..< pointee.count == pointee.indices)
        precondition(0 ..< pointee.count ~= limbs, NBK.callsiteOutOfBoundsInfo())
        precondition(1 ..< UInt.bitWidth ~= bits,  NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initWithFastPaths(truncating: bits, as: Limb.self)
        let pull = NBK.initWithFastPaths(truncating: UInt.bitWidth - bits, as: Limb.self)
        let fill = Limb(repeating: environment)
        //=--------------------------------------=
        var destination = pointee.endIndex as Int
        let offset: Int = ~(limbs)
        var element = pointee[destination &+ offset]
        //=--------------------------------------=
        while destination > pointee.startIndex {
            pointee.formIndex(before: &destination)
            let pushed = element &<< push
            element = destination > limbs ? pointee[destination &+ offset] : fill
            let pulled = element &>> pull
            pointee[destination] = pushed | pulled
        }
    }
    
    /// Performs a left shift on a least-to-most-significant limb collection.
    ///
    /// - Parameters:
    ///   - pointee: The mutable collection.
    ///   - environment: The bit used to fill the void.
    ///   - limbs: `1 <= limbs < pointee.count`
    ///
    @inline(__always) @inlinable public static func bitshiftLeftAsFixedLimbsCodeBlock<T>(
    _ pointee: inout T, environment: Bool, atLeastOneLimb limbs: Int)
    where T: RandomAccessCollection & MutableCollection, T.Element: NBKCoreInteger & NBKUnsignedInteger, T.Indices == Range<Int> {
        typealias Limb = T.Element
        precondition(0 ..< pointee.count == pointee.indices)
        precondition(1 ..< pointee.count ~= limbs, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let fill = Limb(repeating: environment)
        //=--------------------------------------=
        for destination in pointee.indices.reversed() {
            pointee[destination] = destination >= limbs ? pointee[destination - limbs] : fill
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Right
    //=------------------------------------------------------------------------=
    
    /// Performs a right shift on a least-to-most-significant limb collection.
    ///
    /// - Parameters:
    ///   - pointee: The mutable collection.
    ///   - environment: The bit used to fill the void.
    ///   - limbs: `0 <= limbs < pointee.count`
    ///   - bits:  `1 <= bits  < Limb.bitWidth`
    ///
    @inline(__always) @inlinable public static func bitshiftRightAsFixedLimbsCodeBlock<T>(
    _ pointee: inout T, environment: Bool, limbs: Int, atLeastOneBit bits: Int)
    where T: RandomAccessCollection & MutableCollection, T.Element: NBKCoreInteger & NBKUnsignedInteger, T.Indices == Range<Int> {
        typealias Limb = T.Element
        precondition(0 ..< pointee.count == pointee.indices)
        precondition(0 ..< pointee.count ~= limbs, NBK.callsiteOutOfBoundsInfo())
        precondition(1 ..< UInt.bitWidth ~= bits,  NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initWithFastPaths(truncating: bits, as: Limb.self)
        let pull = NBK.initWithFastPaths(truncating: UInt.bitWidth - bits, as: Limb.self)
        let fill = Limb(repeating: environment)
        //=--------------------------------------=
        var destination = pointee.startIndex
        let edge = pointee.distance(from: limbs, to: pointee.endIndex)
        var element = pointee[limbs] as Limb
        //=--------------------------------------=
        while destination < pointee.endIndex {
            let after  = pointee.index(after: destination)
            let pushed = element &>> push
            element = after < edge ? pointee[after &+ limbs] : fill
            let pulled = element &<< pull
            pointee[destination] = pushed | pulled
            destination = after
        }
    }
    
    /// Performs a right shift on a least-to-most-significant limb collection.
    ///
    /// - Parameters:
    ///   - pointee: The mutable collection.
    ///   - environment: The bit used to fill the void.
    ///   - limbs: `1 <= limbs < pointee.count`
    ///
    @inline(__always) @inlinable public static func bitshiftRightAsFixedLimbsCodeBlock<T>(
    _ pointee: inout T, environment: Bool, atLeastOneLimb limbs: Int)
    where T: RandomAccessCollection & MutableCollection, T.Element: NBKCoreInteger & NBKUnsignedInteger, T.Indices == Range<Int> {
        typealias Limb = T.Element
        precondition(0 ..< pointee.count == pointee.indices)
        precondition(1 ..< pointee.count ~= limbs, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=--=
        let fill = Limb(repeating: environment)
        //=--------------------------------------=
        let edge = pointee.distance(from: limbs, to: pointee.endIndex)
        //=--------------------------------------=
        for destination in pointee.indices {
            pointee[destination] = destination < edge ? pointee[destination + limbs] : fill
        }
    }
}
