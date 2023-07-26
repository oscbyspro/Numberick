//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Stdlib
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Creates a description from an integer by using Swift's standard library method.
    @inlinable public static func descriptionAsStdlib(
    _ source: some Swift.BinaryInteger, radix: Int = 10, uppercase: Bool = false) -> String {
        String.init(source, radix: radix, uppercase: uppercase)
    }
    
    /// Creates an integer from a description by using Swift's standard library method.
    @inlinable public static func integerAsStdlib<T: Swift.FixedWidthInteger>(
    _ source: some StringProtocol, radix: Int = 10, as type: T.Type = T.self) -> Optional<T> {
        T.init(source, radix: radix)
    }
}
