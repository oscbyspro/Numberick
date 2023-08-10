//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x IntegerLiteral
//*============================================================================*

#if swift(>=5.8)

@available (iOS 16.4, tvOS 16.4, macOS 13.3, watchOS 9.4, macCatalyst 16.4, *)
extension NBKDoubleWidth {
    public typealias IntegerLiteralType = StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: StaticBigInt) {
        guard let value = Self(exactlyIntegerLiteral: source) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = value
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

#endif

extension NBKDoubleWidth {
    @inlinable public init(integerLiteral source: Int64) {
        self.init(source)
    }
}
