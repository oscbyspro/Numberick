# ``Numberick``

✨ An arithmagick overhaul in Swift.

## NBKCoreKit

A new protocol hierarchy that refines Swift's standard library.

### Protocols

- ``NBKBinaryInteger``
- ``NBKBitPatternConvertible``
- ``NBKCoreInteger``
- ``NBKFixedWidthInteger``
- ``NBKSignedInteger``
- ``NBKUnsignedInteger``

### Models

- ``NBKEndianness``
- ``NBKMajorOrMinorInteger``
- ``NBKTwinHeaded``

## NBKDoubleWidthKit

A composable, large, fixed-width, two's complement, binary integer.

### 🧩 Composable

``NBKDoubleWidth`` is a generic software model for working with fixed-width
integers larger than one machine word. Its bit width is double the bit width of
its `High` component. In this way, you may construct new integer types:

```swift
typealias  Int256 = NBKDoubleWidth< Int128>
typealias UInt256 = NBKDoubleWidth<UInt128>
```

### 💕 Two's Complement

Like other binary integers, ``NBKDoubleWidth`` has two's complement semantics. 

```
The two's complement representation of  0 is an infinite sequence of 0s.
The two's complement representation of -1 is an infinite sequence of 1s.
```

### 🏰 Fixed-Width Integer

Each type of ``NBKDoubleWidth`` has a fixed bit width, and so do its halves.
This design comes with a suite of overflow and bit-casting operations. The 
even split also lends itself to divide-and-conquer strategies. As such, it 
leverages A. Karatsuba's multiplication algorithm, as well as C. Burnikel's
and J. Ziegler's fast recursive division.

### 📖 Trivial UInt Collection

``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
unsigned machine word. It contains at least two words, but the exact count
depends on the platform's architecture. You should, therefore, use
properties like `startIndex` and `endIndex` instead of hard-coded indices.

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

Swift's type system enforces proper layout insofar as `Int` and `UInt` are the
only types in the standard library that meet its type requirements. 
Specifically, only `Int` and `UInt` have `NBKCoreInteger<UInt>` `Digit` types.

### 🚀 Single Digit Arithmagick

Alongside its ordinary arithmagick operations, ``NBKDoubleWidth`` provides
single-digit operations, where a digit is an un/signed machine word. These
operations are more efficient for small calculations. Here are some examples:

```swift
Int256(1) + Int(1), UInt256(1) + UInt(1)
Int256(2) - Int(2), UInt256(2) - UInt(2)
Int256(3) * Int(3), UInt256(3) * UInt(3)
Int256(4) / Int(4), UInt256(4) / UInt(4)
Int256(5) % Int(5), UInt256(5) % UInt(5)
```

- Note: The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.

### ⭐️ Feature: StaticBigInt (v0.10.0+)

`StaticBigInt` is disabled by default. You enable it in `Package.swift`.

- Note: You can use `StaticString` until `StaticBigInt` becomes available.

## Topics

### Protocols

- ``NBKBinaryInteger``
- ``NBKBitPatternConvertible``
- ``NBKCoreInteger``
- ``NBKFixedWidthInteger``
- ``NBKSignedInteger``
- ``NBKUnsignedInteger``

### Models

- ``NBKDoubleWidth``
- ``NBKEndianness``
- ``NBKMajorOrMinorInteger``
- ``NBKTwinHeaded``

### Integers

- ``Int128``
- ``Int256``
- ``Int512``
- ``Int1024``
- ``Int2048``
- ``Int4096``

- ``UInt128``
- ``UInt256``
- ``UInt512``
- ``UInt1024``
- ``UInt2048``
- ``UInt4096``

### Abbreviations

- ``HL``
- ``LH``
- ``PVO``
- ``QR``
- ``NBK``
