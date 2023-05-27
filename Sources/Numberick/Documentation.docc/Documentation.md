# ``Numberick``

Large number arithmagick in Swift.

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
than one machine word. Its bit width is double the bit width of its `High`
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

Each specialization of ``NBKDoubleWidth`` has a fixed bit width, and so do its
halves. This design comes with a suite of overflow and bit-casting operations.
The even partition also lends itself to divide-and-conquer strategies. As such,
it uses A. Karatsuba's multiplication algorithm, as well as C. Burnikel's and
J. Ziegler's fast recursive division.

### 📖 Trivial UInt Collection

``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
unsigned machine word. Its `High` component must therefore be trivial and 
layout compatible with some machine word aggregate. This layout constraint
enables direct access to its machine words.

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

Proper layout is enforced by the type system insofar as `Int` and `UInt` are
the only types in the standard library that meet its type constraints. 
Specifically, only `Int` and `UInt` have `NBKCoreInteger<UInt>` `Digit` types.

### 🚀 Single Digit Arithmetic

Alongside its ordinary arithmetic operations, ``NBKDoubleWidth`` also provides
single-digit operations, where a digit is an un/signed machine word. These
operations are more efficient for small calculations. Here are some examples:

```swift
Int256(1) + Int(1)
Int256(2) - Int(2)
Int256(3) * Int(3)
Int256(4) / Int(4)
Int256(5) % Int(5)
```

- Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.