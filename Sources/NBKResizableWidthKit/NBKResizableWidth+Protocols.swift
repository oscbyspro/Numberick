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
// MARK: * NBK x Resizable Width x IntXR or UIntXR
//*============================================================================*

public protocol IntXROrUIntXR: NBKBinaryInteger, LosslessStringConvertible, MutableCollection,
RandomAccessCollection where Element == UInt, Index == Int, Indices == Range<Int> { }
