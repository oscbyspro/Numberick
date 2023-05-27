# ``Numberick``

Large number arithmetic in Swift.

## NBKCoreKit

Models, protocols, and utilities underpinning this package.

### Protocols

- ``NBKBinaryInteger``
- ``NBKBitPatternConvertible``
- ``NBKCoreInteger``
- ``NBKFixedWidthInteger``
- ``NBKSignedInteger``
- ``NBKUnsignedInteger``

## NBKDoubleWidthKit

A composable, large, fixed-width, two's complement, binary integer.

### 🧩 Composable

``NBKDoubleWidth`` is a model for working with fixed-width integers larger
than a single machine word. Its bit width is double the bit width of its `High`
component. In this way, you may construct new integer types:

```swift
typealias  Int256 = NBKDoubleWidth< Int128>
typealias UInt256 = NBKDoubleWidth<UInt128>
```

### 💕 Two's Complement

Like other binary integers, ``NBKDoubleWidth`` has two's complement semantics. 

```
The two's complement representation of +0 is an infinite sequence of 0s.
The two's complement representation of -1 is an infinite sequence of 1s.
```

### 🏰 Fixed Width Integer

Each instance of ``NBKDoubleWidth`` has the same bit width, as does all of its
constituent parts. With this design comes a suite of arithmetic operations for
handling overflow. It is also safe to bit cast between un/signed instances.

Because it is split into halves, it is well suited for divide-and-conquer
strategies. As such, it employs adaptations of A. Karatsuba's multiplication 
algorithm, as well as C. Burnikel's and J. Ziegler's fast recursive division.

### 📖 Trivial UInt Collection

``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
unsigned machine word. Its `High` component must therefore be trivial and 
layout compatible with some machine word aggregate. This layout constraint
makes it possible to operate on its machine words directly.

```
// Int256 and UInt256, as constructed on a 64-bit platform:
┌───────────────────────────┐ ┌───────────────────────────┐
│           Int256          │ │          UInt256          │
├─────────────┬─────────────┤ ├─────────────┬─────────────┤
│    Int128   │   UInt128   │ │   UInt128   │   UInt128   │
├──────┬──────┼──────┬──────┤ ├──────┬──────┼──────┬──────┤
│  Int │ UInt │ UInt │ UInt │ │ UInt │ UInt │ UInt │ UInt │
└──────┴──────┴──────┴──────┘ └──────┴──────┴──────┴──────┘
```

This layout is statically enforced, to some extent, using the type system
knowledge that `Int` and `UInt` are the only types in the standard library
that meet its requirements. Specifically, only `Int` and `UInt` have `Digit`
types that conform to `NBKCoreInteger<UInt>`.

### 🚀 Single Digit Arithmetic

Alongside its ordinary arithmetic operations, ``NBKDoubleWidth`` also provides
single-digit operations, where a digit is an un/signed machine word. These
operations are more efficient for small calculations. Here are some examples:

```swift
Int256.max + Int(1)
Int256.max - Int(2)
Int256.max * Int(3)
Int256.max / Int(4)
```

- Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.
