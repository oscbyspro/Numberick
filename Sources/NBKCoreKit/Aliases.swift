//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Aliases
//*============================================================================*

/// A high and a low value.
public typealias HL<H,L> = (high: H, low: L)

/// An index and an overflow indicator.
public typealias IO<I> = (index: I, overflow: Bool)

/// A low and a high value.
public typealias LH<L,H> = (low: L, high: H)

/// A partial value and an overflow indicator.
public typealias PVO<PV> = (partialValue: PV, overflow: Bool)

/// A quotient and a remainder, relating to division.
public typealias QR<Q,R> = (quotient: Q, remainder: R)

/// A sign and a magnitude.
public typealias SM<M> = (sign: FloatingPointSign, magnitude: M)
