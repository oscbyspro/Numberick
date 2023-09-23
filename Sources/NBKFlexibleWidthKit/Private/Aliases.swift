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
// MARK: * NBK x Aliases
//*============================================================================*

@usableFromInline typealias SBI<Base> = NBK.StrictBinaryInteger<Base> where
Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

@usableFromInline typealias SBISS<Base> = NBK.StrictBinaryInteger<Base>.SubSequence where
Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

@usableFromInline typealias SUI<Base> = NBK.StrictUnsignedInteger<Base> where
Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger

@usableFromInline typealias SUISS<Base> = NBK.StrictUnsignedInteger<Base>.SubSequence where
Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger
