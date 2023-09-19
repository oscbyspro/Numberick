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
// MARK: * NBK x Offset Access Collection x Swift
//*============================================================================*

extension Array:                         NBKOffsetAccessCollection { }
extension ContiguousArray:               NBKOffsetAccessCollection { }
extension UnsafeBufferPointer:           NBKOffsetAccessCollection { }
extension UnsafeMutableBufferPointer:    NBKOffsetAccessCollection { }
extension UnsafeRawBufferPointer:        NBKOffsetAccessCollection { }
extension UnsafeMutableRawBufferPointer: NBKOffsetAccessCollection { }

//=----------------------------------------------------------------------------=
// MARK: + Binary Integer Words
//=----------------------------------------------------------------------------=

extension Int   .Words: NBKOffsetAccessCollection { }
extension Int8  .Words: NBKOffsetAccessCollection { }
extension Int16 .Words: NBKOffsetAccessCollection { }
extension Int32 .Words: NBKOffsetAccessCollection { }
extension Int64 .Words: NBKOffsetAccessCollection { }

extension UInt  .Words: NBKOffsetAccessCollection { }
extension UInt8 .Words: NBKOffsetAccessCollection { }
extension UInt16.Words: NBKOffsetAccessCollection { }
extension UInt32.Words: NBKOffsetAccessCollection { }
extension UInt64.Words: NBKOffsetAccessCollection { }
