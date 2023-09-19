//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Offset Access Collection
//*============================================================================*

/// A random access collection with indices from `zero` to `count`.
public protocol NBKOffsetAccessCollection<Element>: RandomAccessCollection where Indices == Range<Int> { }

//*============================================================================*
// MARK: * NBK x Offset Indexed x Swift
//*============================================================================*

extension Array:                         NBKOffsetAccessCollection { }
extension ContiguousArray:               NBKOffsetAccessCollection { }
extension UnsafeBufferPointer:           NBKOffsetAccessCollection { }
extension UnsafeMutableBufferPointer:    NBKOffsetAccessCollection { }
extension UnsafeRawBufferPointer:        NBKOffsetAccessCollection { }
extension UnsafeMutableRawBufferPointer: NBKOffsetAccessCollection { }
