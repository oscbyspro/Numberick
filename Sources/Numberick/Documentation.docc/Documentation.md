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

- ``NBKChunkedInt``
- ``NBKEndianness``
- ``NBKPrimeSieve``
- ``NBKStaticBigInt``

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

## NBKFlexibleWidthKit

> [!IMPORTANT]
> It's a work in progress. I may rework it at any time.

### Models

- ``NBKFibonacciXL``
- ``UIntXL``

### Fibonacci

```swift
NBKFibonacciXL(0) // (index: 0, element: 0, next: 1)
NBKFibonacciXL(1) // (index: 1, element: 1, next: 1)
NBKFibonacciXL(2) // (index: 2, element: 1, next: 2)
NBKFibonacciXL(3) // (index: 3, element: 2, next: 3)
NBKFibonacciXL(4) // (index: 4, element: 3, next: 5)
NBKFibonacciXL(5) // (index: 5, element: 5, next: 8)
```

It uses a fast double-and-add algorithm:

```swift
NBKFibonacciXL(10_000_000) // 2.3s on MacBook Pro, 13-inch, M1, 2020
```

But you can also step through it manually:

```swift
mutating func increment() { ... } // index + 1
mutating func decrement() { ... } // index - 1
mutating func    double() { ... } // index * 2
```

## Topics

### Protocols

- ``NBKBinaryInteger``
- ``NBKBitPatternConvertible``
- ``NBKCoreInteger``
- ``NBKFixedWidthInteger``
- ``NBKSignedInteger``
- ``NBKUnsignedInteger``

### Models

- ``NBKChunkedInt``
- ``NBKDoubleWidth``
- ``NBKEndianness``
- ``NBKFlexibleWidth``
- ``NBKPrimeSieve``
- ``NBKStaticBigInt``

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
- ``UIntXL``

### Abbreviations

- ``HL``
- ``IO``
- ``LH``
- ``PVO``
- ``QR``
- ``SM``

### Namespaces

- ``NBK``
