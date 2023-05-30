# [Numberick][NBK/D]

Large number arithmagick in Swift.

| Release | Swift | iOS  | iPadOS | Mac Catalyst | macOS | tvOS | watchOS |
|:-------:|:-----:|:----:|:------:|:------------:|:-----:|:----:|:-------:|
| 0.1.0   | 5.8   | 16.4 | 16.4   | 16.4         | 13.3  | 16.4 | 9.4     |

## NBKCoreKit ([Sources][COR/S], [Tests][COR/T], [Benchmarks][COR/B])

Models, protocols, and utilities underpinning this package.

### Protocols

- [NBKBinaryInteger](Sources/NBKCoreKit/NBKBinaryInteger.swift)
- [NBKBitPatternConvertible](Sources/NBKCoreKit/NBKBitPatternConvertible.swift)
- [NBKCoreInteger](Sources/NBKCoreKit/NBKCoreInteger.swift)
- [NBKFixedWidthInteger](Sources/NBKCoreKit/NBKFixedWidthInteger.swift)
- [NBKSignedInteger](Sources/NBKCoreKit/NBKBinaryInteger.swift)
- [NBKUnsignedInteger](Sources/NBKCoreKit/NBKBinaryInteger.swift)

## [NBKDoubleWidthKit][DBL/D] ([Sources][DBL/S], [Tests][DBL/T], [Benchmarks][DBL/B])

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
unsigned machine word. It contains at least two words, and its word count
is always a power of two. This layout enables direct machine word access. 
The exact count depends on the platform's architecture. You should, therefore,
use properties like `startIndex` and `endIndex` instead of hard-coded indices.

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

### 🚀 Single Digit Arithmetic

Alongside its ordinary arithmetic operations, ``NBKDoubleWidth`` also provides
single-digit operations, where a digit is an un/signed machine word. These
operations are more efficient for small calculations. Here are some examples:

```swift
Int256(1) + Int(1) │ UInt256(1) + UInt(1)
Int256(2) - Int(2) │ UInt256(2) - UInt(2)
Int256(3) * Int(3) │ UInt256(3) * UInt(3)
Int256(4) / Int(4) │ UInt256(4) / UInt(4)
Int256(5) % Int(5) │ UInt256(5) % UInt(5)
```

> **Note:**  The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.

## Acknowledgement

This project is inspired by [Int128][Apple/Int128] and [DoubleWidth][Apple/DoubleWidth] by Apple.

<!-- Links -->

[NBK/D]: https://oscbyspro.github.io/Numberick/documentation/numberick
[DBL/D]: https://oscbyspro.github.io/Numberick/documentation/numberick/nbkdoublewidth

[COR/S]: Sources/NBKCoreKit
[DBL/S]: Sources/NBKDoubleWidthKit

[COR/T]: Tests/NBKCoreKitTests
[DBL/T]: Tests/NBKDoubleWidthKitTests

[COR/B]: Tests/NBKCoreKitBenchmarks
[DBL/B]: Tests/NBKDoubleWidthKitBenchmarks

<!-- Links x Acknowledgement -->

[Apple/Int128]: https://github.com/apple/swift/blob/main/stdlib/public/core/Int128.swift.gyb
[Apple/DoubleWidth]: https://github.com/apple/swift/blob/main/test/Prototypes/DoubleWidth.swift.gyb
