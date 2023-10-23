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
// MARK: * NBK x Flexible Width x Text x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decoding
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: some StringProtocol, radix: Int) {
        let decoder = NBK.IntegerDescription.Decoder<Magnitude>(radix: radix)
        guard let components: SM<Magnitude> = decoder.decode(description) else { return nil }
        self.init(sign: components.sign, magnitude: components.magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encoding
    //=------------------------------------------------------------------------=
    
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        NBK.IntegerDescription.Encoder(radix: radix, uppercase: uppercase).encode(self)
    }
}
