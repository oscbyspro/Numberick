//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK
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
    
    /// An unsafe pointer to a collection of succinct `UInt` machine words.
    public typealias UnsafeSuccinctWords = (body: NBK.UnsafeWords, sign: Bool)
    
    /// An index and an overflow indicator.
    public typealias IO<I> = (index: I, overflow: Bool)
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases x Tuples
    //=------------------------------------------------------------------------=
    
    /// A 128-bit pattern split into `UInt64` words.
    public typealias U128X64 = (UInt64, UInt64)

    /// A 128-bit pattern split into `UInt32` words.
    public typealias U128X32 = (UInt32, UInt32, UInt32, UInt32)
    
    /// A 256-bit pattern split into `UInt64` words.
    public typealias U256X64 = (UInt64, UInt64, UInt64, UInt64)

    /// A 256-bit pattern split into `UInt32` words.
    public typealias U256X32 = (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    
    /// An integer split into two parts.
    public typealias Wide2<T> = (high: T, low: T.Magnitude) where T: NBKFixedWidthInteger

    /// An integer split into three parts.
    public typealias Wide3<T> = (high: T, mid: T.Magnitude, low: T.Magnitude) where T: NBKFixedWidthInteger
    
    //=------------------------------------------------------------------------=
    // MARK: Namespaces
    //=------------------------------------------------------------------------=
    
    /// A namespace for `Numberick` development.
    ///
    /// - Warning: Do not use this namespace outside of `Numberick` development.
    ///
    public typealias SBI<Base> =  NBK.StrictBinaryInteger<Base> where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

    /// A namespace for `Numberick` development.
    ///
    /// - Warning: Do not use this namespace outside of `Numberick` development.
    ///
    public typealias SBISS<Base>  = NBK.StrictBinaryInteger<Base>.SubSequence where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

    /// A namespace for `Numberick` development.
    ///
    /// - Warning: Do not use this namespace outside of `Numberick` development.
    ///
    public typealias SSI<Base> =  NBK.StrictSignedInteger<Base> where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

    /// A namespace for `Numberick` development.
    ///
    /// - Warning: Do not use this namespace outside of `Numberick` development.
    ///
    public typealias SSISS<Base>  = NBK.StrictSignedInteger<Base>.SubSequence where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

    /// A namespace for `Numberick` development.
    ///
    /// - Warning: Do not use this namespace outside of `Numberick` development.
    ///
    public typealias SUI<Base> =  NBK.StrictUnsignedInteger<Base> where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

    /// A namespace for `Numberick` development.
    ///
    /// - Warning: Do not use this namespace outside of `Numberick` development.
    ///
    public typealias SUISS<Base>  = NBK.StrictUnsignedInteger<Base>.SubSequence where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger
}
