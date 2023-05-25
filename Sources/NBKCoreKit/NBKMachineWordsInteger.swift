//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Machine Words Integer
//*============================================================================*

/// A fixed-width, binary, integer suitable for direct machine word access.
///
/// Conforming types must trivial and layout compatible with some multiple of `UInt` words.
///
/// ```swift
/// let storage: (UInt32, UInt32) // ✅ works
/// let storage: (UInt16, UInt16) // ⚠️ works on 32-bit platforms
/// let storage: (UInt16, UInt32) // 🚨 wrong size
/// let storage: [UInt64]         // 🚨 nontrivial
/// ```
///
public protocol NBKMachineWordsInteger: NBKFixedWidthInteger where Digit: NBKMachineWordsInteger, Magnitude: NBKMachineWordsInteger { }

//*============================================================================*
// MARK: * NBK x Machine Words Integer x Swift
//*============================================================================*

extension Int:    NBKMachineWordsInteger { }
extension Int64:  NBKMachineWordsInteger { }
extension UInt:   NBKMachineWordsInteger { }
extension UInt64: NBKMachineWordsInteger { }
