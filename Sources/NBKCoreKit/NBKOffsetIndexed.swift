//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Offset Indexed
//*============================================================================*

public protocol NBKOffsetIndexed<Element>: RandomAccessCollection where Indices == Range<Int> { }

//*============================================================================*
// MARK: * NBK x Offset Indexed x Swift
//*============================================================================*

extension Array:                         NBKOffsetIndexed { }
extension ContiguousArray:               NBKOffsetIndexed { }
extension UnsafeBufferPointer:           NBKOffsetIndexed { }
extension UnsafeMutableBufferPointer:    NBKOffsetIndexed { }
extension UnsafeRawBufferPointer:        NBKOffsetIndexed { }
extension UnsafeMutableRawBufferPointer: NBKOffsetIndexed { }
