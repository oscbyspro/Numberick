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
// MARK: * NBK x Double With x Integer As Text
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(decoding description: some StringProtocol, radix: Int?) {
        var description = String(description)
        //=--------------------------------------=
        let value = description.withUTF8 { utf8 in
            let (sign, radix, body) = NBK.components(ascii: utf8, radix: radix)
            let magnitude = Magnitude(digits: body, radix: AnyRadixUIntRoot(radix))
            return magnitude.flatMap({ Self(sign: sign, magnitude: $0) })
        }
        //=--------------------------------------=
        if let value { self = value } else { return nil }
    }
    
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        let sign = self.isLessThanZero ? FloatingPointSign.minus : FloatingPointSign.plus
        return self.magnitude.description(sign: sign, radix: radix, uppercase: uppercase)
    }
}

//*============================================================================*
// MARK: * NBK x Double With x Integer As Text x String
//*============================================================================*

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(encoding integer: NBKDoubleWidth<T>, radix: Int = 10, uppercase: Bool = false) {
        self = integer.description(radix: radix, uppercase: uppercase)
    }
}
