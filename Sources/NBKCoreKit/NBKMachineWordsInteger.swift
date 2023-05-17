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

public protocol NBKMachineWordsInteger: NBKFixedWidthInteger where
Digit: NBKMachineWordsInteger, Magnitude: NBKMachineWordsInteger { }

//*============================================================================*
// MARK: * NBK x Machine Words Integer x Swift
//*============================================================================*

extension Int:    NBKMachineWordsInteger { }
extension Int64:  NBKMachineWordsInteger { }
extension UInt:   NBKMachineWordsInteger { }
extension UInt64: NBKMachineWordsInteger { }
