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

/*/SBI*/extension NBKDoubleWidth {
/*/SBI*/
/*/SBI*/   //=-----------------------------------------------------------------=
/*/SBI*/   // MARK: Initializers
/*/SBI*/   //=-----------------------------------------------------------------=
/*/SBI*/
/*/SBI*/   @inlinable public init(integerLiteral source: StaticBigInt) {
/*/SBI*/       if  let value = Self(exactlyIntegerLiteral: source) { self = value } else {
/*/SBI*/           preconditionFailure("\(Self.description) cannot represent \(source)")
/*/SBI*/       }
/*/SBI*/   }
/*/SBI*/
/*/SBI*/   @inlinable init?(exactlyIntegerLiteral source: StaticBigInt) {
/*/SBI*/       guard Self.isSigned
/*/SBI*/       ? source.bitWidth <= Self.bitWidth
/*/SBI*/       : source.bitWidth <= Self.bitWidth + 1 && source.signum() >= 0
/*/SBI*/       else { return nil }
/*/SBI*/
/*/SBI*/       self = Self.uninitialized { value in
/*/SBI*/           for index in value.indices {
/*/SBI*/               value[unchecked: index] = source[index]
/*/SBI*/           }
/*/SBI*/       }
/*/SBI*/   }
/*/SBI*/}

//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

//*SBI*/extension NBKDoubleWidth {
//*SBI*/
//*SBI*/    //=----------------------------------------------------------------=
//*SBI*/    // MARK: Initializers
//*SBI*/    //=----------------------------------------------------------------=
//*SBI*/
//*SBI*/    @inlinable public init(integerLiteral source: Int64) {
//*SBI*/        self.init(source)
//*SBI*/    }
//*SBI*/}
