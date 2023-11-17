# [Numberick][NBK/D]

✨ An arithmagick overhaul in Swift.

| Package | Swift | iOS   | Mac Catalyst | macOS | tvOS  | watchOS |
|:-------:|:-----:|:-----:|:------------:|:-----:|:-----:|:-------:|
| 0.15.0  | 5.7   | 14.0  | 14.0         | 11.0  | 14.0  | 7.0     |

## Table of Contents

* [NBKCoreKit](#nbkcorekit)
* [NBKDoubleWidthKit](#nbkdoublewidthkit)
* [NBKFlexibleWidthKit](#nbkflexiblewidthkit)
* [Installation](#installation)
* [Acknowledgements](#acknowledgements)

<a name="nbkcorekit"/>

## NBKCoreKit ([Sources][COR/S], [Tests][COR/T], [Benchmarks][COR/B])

A new protocol hierarchy that refines Swift's standard library.

### Protocols

- [NBKBinaryInteger](Sources/NBKCoreKit/NBKBinaryInteger.swift)
- [NBKBitPatternConvertible](Sources/NBKCoreKit/NBKBitPatternConvertible.swift)
- [NBKCoreInteger](Sources/NBKCoreKit/NBKCoreInteger.swift)
- [NBKFixedWidthInteger](Sources/NBKCoreKit/NBKFixedWidthInteger.swift)
- [NBKSignedInteger](Sources/NBKCoreKit/NBKSignedInteger.swift)
- [NBKUnsignedInteger](Sources/NBKCoreKit/NBKUnsignedInteger.swift)

### Models

- [NBKChunkedInt](Sources/NBKCoreKit/Models/NBKChunkedInt.swift)
- [NBKEndianness](Sources/NBKCoreKit/Models/NBKEndianness.swift)
- [NBKStaticBigInt](Sources/NBKCoreKit/Models/NBKStaticBigInt.swift)

<a name="nbkdoublewidthkit"/>

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

Each ``NBKDoubleWidth`` has a fixed bit width, and so do its halves. 
This design comes with a suite of overflow and bit-casting operations. 
The even split also lends itself to divide-and-conquer strategies.

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

> [!NOTE]
> The `Digit` type is `Int` when `Self` is signed, and `UInt` otherwise.

### ⭐️ Feature: Swift.StaticBigInt

`StaticBigInt` is disabled by default. You enable it in `Package.swift`.

> [!NOTE]
> You can use `StaticString` until `StaticBigInt` becomes available.

<a name="nbkflexiblewidthkit"/>

## [NBKFlexibleWidthKit][FLX/D] ([Sources][FLX/S], [Tests][FLX/T], [Benchmarks][FLX/B])

👨‍💻🛠️🚧🧱🧱🏗️🧱🧱🚧⏳

### Models

- [NBKFibonacciXL](Sources/NBKFlexibleWidthKit/Models/NBKFibonacciXL.swift)

### Fibonacci

This sequence is instrumental for testing big integers, and it's fun.

```swift
NBKFibonacciXL(0) // (index: 0, element: 0, next: 1)
NBKFibonacciXL(1) // (index: 1, element: 1, next: 1)
NBKFibonacciXL(2) // (index: 2, element: 1, next: 2)
NBKFibonacciXL(3) // (index: 3, element: 2, next: 3)
NBKFibonacciXL(4) // (index: 4, element: 3, next: 5)
NBKFibonacciXL(5) // (index: 5, element: 5, next: 8)
```

It uses a fast double-and-add algorithm to calculate silly numbers quickly.

```swift
NBKFibonacciXL(10_000_000) // 2.3s on M1 MacBook Pro
```
Or you can step through it manually if that's your preferred cup of tea.

```swift
public mutating func increment() { ... } // index + 1
public mutating func decrement() { ... } // index - 1
public mutating func    double() { ... } // index * 2
```

<a name="installation"/>

## Installation

Numberick contains several modules. Import some or all of them.

### [SemVer 2.0.0](https://semver.org)

> Major version zero (0.y.z) is for initial development.
>
> Anything MAY change at any time. 
>
> The public API SHOULD NOT be considered stable.

### Using [SwiftPM](https://swift.org/package-manager)

Add this package to your list of package dependencies.

```swift
.package(url: "https://github.com/oscbyspro/Numberick.git", .upToNextMinor(from: "0.15.0")),
```

Choose target dependencies from the products in [Package.swift](Package.swift).

```swift
.product(name: "Numberick",         package: "Numberick"),
.product(name: "NBKCoreKit",        package: "Numberick"),
.product(name: "NBKDoubleWidthKit", package: "Numberick"),
```

### Using [CocoaPods](http://cocoapods.org)

Choose target dependencies from the pods listed in the root directory.

```rb
pod "Numberick",                   "~> 0.15.0"
pod "Numberick-NBKCoreKit",        "~> 0.15.0"
pod "Numberick-NBKDoubleWidthKit", "~> 0.15.0"
```

<a name="acknowledgements"/>

## Acknowledgements

This project is inspired by [**Int128**][Apple/Int128] and [**DoubleWidth**][Apple/DoubleWidth] by Apple.

<!-- Links -->

[NBK/D]: https://oscbyspro.github.io/Numberick/documentation/numberick
[DBL/D]: https://oscbyspro.github.io/Numberick/documentation/numberick/nbkdoublewidth
[FLX/D]: https://oscbyspro.github.io/Numberick/documentation/numberick/nbkflexiblewidth
[SIG/D]: https://oscbyspro.github.io/Numberick/documentation/numberick/nbksigned

[COR/S]: Sources/NBKCoreKit
[DBL/S]: Sources/NBKDoubleWidthKit
[FLX/S]: Sources/NBKFlexibleWidthKit

[COR/T]: Tests/NBKCoreKitTests
[DBL/T]: Tests/NBKDoubleWidthKitTests
[FLX/T]: Tests/NBKFlexibleWidthKitTests

[COR/B]: Tests/NBKCoreKitBenchmarks
[DBL/B]: Tests/NBKDoubleWidthKitBenchmarks
[FLX/B]: Tests/NBKFlexibleWidthKitBenchmarks

<!-- Links x Miscellaneous -->

[Apple/Int128]: https://github.com/apple/swift/blob/main/stdlib/public/core/Int128.swift.gyb
[Apple/DoubleWidth]: https://github.com/apple/swift/blob/main/test/Prototypes/DoubleWidth.swift.gyb
