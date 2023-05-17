# ``NBKFullWidthKit``

A composable, large, fixed-width, two's complement, binary integer.

## Overview

A composable, large, fixed-width, two's complement, binary integer.

``NBKDoubleWidth`` is a generic model for working with fixed-width integers larger
than 64 bits. Its bit width is double the bit width of its ``NBKDoubleWidth/High-swift.typealias``
component. In this way, you may construct new integer types:

```swift
typealias  Int256 = NBKDoubleWidth< Int128>
typealias UInt256 = NBKDoubleWidth<UInt128>
```

### Trivial UInt Collection

``NBKDoubleWidth`` models a trivial `UInt` collection. Its ``NBKDoubleWidth/High-swift.typealias``
component must therefore be trivial and a whole integer multiple of `UInt.bitWidth`. This layout
constraint makes it possible to operate on its words directly.

- Note: Integers with such layout conform to ``NBKMachineWordsInteger``.

### Single Digit Arithmetic

Alongside ordinary arithmetic operations, ``NBKDoubleWidth`` also offers single digit operations,
where a digit is an un/signed machine word. These operations provide a more efficient alternative
for small calculations. See the following for more details:

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
