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
// MARK: * NBK x Flexible Width x IntXL or UIntXL x Storage
//*============================================================================*

@usableFromInline protocol IntXLOrUIntXLStorage: NBKBitPatternConvertible where BitPattern == UIntXL.Storage {
    
    associatedtype Digit: NBKCoreInteger<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool { get }
    
    @inlinable mutating func normalize()
    
    @inlinable mutating func normalize(update value: Digit)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Size
    //=------------------------------------------------------------------------=
            
    @inlinable mutating func resize(minCount: Int)
    
    @inlinable mutating func resize(maxCount: Int)
}

//*============================================================================*
// MARK: * NBK x Flexible Width x IntXL or UIntXL x Storage x Private
//*============================================================================*

@usableFromInline protocol PrivateIntXLOrUIntXLStorage: IntXLOrUIntXLStorage {
    
    typealias Elements = NBKFlexibleWidth.Elements
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A collection of unsigned integers.
    ///
    /// It must be `nonempty` at the start and end of each access.
    ///
    @inlinable var elements: Elements { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ elements: Elements)
    
    @inlinable init(unchecked elements: Elements)
    
    @inlinable init(nonemptying elements: Elements)
}
