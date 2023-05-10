//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Whole Machine Words
//*============================================================================*

public protocol WholeMachineWords { }

//*============================================================================*
// MARK: * Whole Machine Words x Swift
//*============================================================================*

extension  Int: WholeMachineWords { }
extension UInt: WholeMachineWords { }
