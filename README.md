# Numberick

👨‍💻🛠️🚧🧱🧱🏗️🧱🧱🚧⏳

Large number arithmetic in Swift.

## NBKCoreKit ([Sources][COR/S], [Tests][COR/T], [Benchmarks][COR/B])

Models, protocols, and extensions underpinning this package.

## NBKDoubleWidthKit ([Sources][DOU/S], [Tests][DOU/T], [Benchmarks][DOU/B])

A composable, large, fixed-width, two's complement, binary integer.

<table>
<tr><td>:jigsaw:</td><td>Composable</td></tr>
<tr><td>:two_hearts:</td><td>Two's Complement</td></tr>
<tr><td>:european_castle:</td><td>Fixed Width Integer</td></tr>
<tr><td>:book:</td><td>Trivial UInt Collection</td></tr>
</table>

```swift
typealias  Int256 = DoubleWidth< Int128>
typealias UInt256 = DoubleWidth<UInt128>
```

<!-- Links -->

[COR/S]: Sources/NBKCoreKit
[DOU/S]: Sources/NBKDoubleWidthKit

[COR/T]: Tests/NBKCoreKitTests
[DOU/T]: Tests/NBKDoubleWidthKitTests

[COR/B]: Tests/NBKCoreKitBenchmarks
[DOU/B]: Tests/NBKDoubleWidthKitBenchmarks
