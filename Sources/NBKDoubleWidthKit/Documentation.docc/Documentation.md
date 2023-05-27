# ``NBKDoubleWidthKit``

A composable, large, fixed-width, two's complement, binary integer.

## Overview

``NBKDoubleWidth`` is a model for working with fixed-width integers larger
than one machine word. Its bit width is double the bit width of its `High`
component. In this way, you may construct new integer types:

```swift
typealias  Int256 = NBKDoubleWidth< Int128>
typealias UInt256 = NBKDoubleWidth<UInt128>
```

### 📖 Trivial UInt Collection

``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
unsigned machine word. Its `High` component must therefore also be trivial
and layout compatible with some multiple of machine words. This constraint
makes it possible to operate on its machine words directly, through `UInt`.

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

Its layout is statically enforced, to some extent, using the type system
knowledge that only `Int` and `UInt` in the standard library meets its
requirements. Specifically, only `Int` and `UInt` have `Digit` types that
conform to `NBKCoreInteger<UInt>`.

### 🚀 Single Digit Arithmetic

Alongside ordinary arithmetic operations, ``NBKDoubleWidth`` also provides
single digit operations, where a digit is an un/signed machine word. These
operations are more efficient for small calculations. See the following for
more details:

- ``NBKBinaryInteger``
- ``NBKFixedWidthInteger``

- Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.

## Topics

### Models

- ``NBKDoubleWidth``

### Aliases — Integers

- ``Int128``
- ``Int192``
- ``Int256``
- ``Int384``
- ``Int512``
- ``Int1024``
- ``Int2048``
- ``Int4096``

- ``UInt128``
- ``UInt192``
- ``UInt256``
- ``UInt384``
- ``UInt512``
- ``UInt1024``
- ``UInt2048``
- ``UInt4096``
