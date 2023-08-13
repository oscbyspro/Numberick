//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Literals
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Version ≥ iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=
//*SBI-/

extension NBKDoubleWidth {

   //=-------------------------------------------------------------------------=
   // MARK: Initializers
   //=-------------------------------------------------------------------------=

   @inlinable public init(integerLiteral source: StaticBigInt) {
       if  let value = Self(exactlyIntegerLiteral: source) { self = value } else {
           preconditionFailure("\(Self.description) cannot represent \(source)")
       }
   }

   @inlinable init?(exactlyIntegerLiteral source: StaticBigInt) {
       guard Self.isSigned
       ? source.bitWidth <= Self.bitWidth
       : source.bitWidth <= Self.bitWidth + 1 && source.signum() >= 0
       else { return nil }

       self = Self.uninitialized { value in
           for index in value.indices {
               value[unchecked: index] = source[index]
           }
       }
   }
}

//-SBI*/
//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=
/*/SBI-/

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: Int64) {
        self.init(source)
    }
}

/-/SBI*/
