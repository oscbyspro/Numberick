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
// MARK: * NBK x Signed x Words
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>) {
        self.init(words: words, isSigned: true)
    }
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>, isSigned: Bool) {
        let isLessThanZero: Bool = isSigned && words.last?.mostSignificantBit == true
        guard let magnitude = Magnitude(words: NBK.MaybeTwosComplement(words, formTwosComplement: isLessThanZero)) else { return nil }
        self.init(sign: Sign(isLessThanZero), magnitude: magnitude)
    }
}
