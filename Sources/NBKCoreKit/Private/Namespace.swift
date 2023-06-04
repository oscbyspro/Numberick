//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Namespace
//*============================================================================*

/// A namespace for `Numberick` development.
///
/// - Warning: Do not use this namespace outside of `Numberick` development.
///
@frozen public enum NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    /// The sign of a numeric value.
    public typealias Sign = FloatingPointSign

    /// An unsafe pointer to a collection of `UTF-8` code points.
    public typealias UnsafeUTF8 = UnsafeBufferPointer<UInt8>
    
    /// An unsafe pointer to a mutable collection of `UTF-8` code points.
    public typealias UnsafeMutableUTF8 = UnsafeMutableBufferPointer<UInt8>
    
    /// An unsafe pointer to a collection of `UInt` machine words.
    public typealias UnsafeWords = UnsafeBufferPointer<UInt>
    
    /// An unsafe pointer to a mutable collection of `UInt` machine words.
    public typealias UnsafeMutableWords = UnsafeMutableBufferPointer<UInt>
}
