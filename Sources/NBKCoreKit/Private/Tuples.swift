//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuples
//*============================================================================*

extension NBK {
    
    /// A 128-bit pattern, split into `UInt64` words.
    public typealias U128X64 = (UInt64, UInt64)

    /// A 128-bit pattern, split into `UInt32` words.
    public typealias U128X32 = (UInt32, UInt32, UInt32, UInt32)
    
    /// A 256-bit pattern, split into `UInt64` words.
    public typealias U256X64 = (UInt64, UInt64, UInt64, UInt64)

    /// A 256-bit pattern, split into `UInt32` words.
    public typealias U256X32 = (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
}
