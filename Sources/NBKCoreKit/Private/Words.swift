//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Words
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Int or UInt
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the words of `word`.
    @inlinable public static func withUnsafeWords<T>(of word: some NBKCoreInteger<UInt>,
    perform body: (NBK.UnsafeWords) throws -> T) rethrows -> T  {
        try Swift.withUnsafePointer(to: UInt(bitPattern: word)) {
            try body(NBK.UnsafeWords(start: $0, count: 1 as Int))
        }
    }
}
