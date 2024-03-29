//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Collection
//*============================================================================*

extension NBK.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns the first element.
    @inlinable public static func prefix1<Base: Collection>(
    _   base: Base) -> Wide1 where Base.Element == High.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix1(base, pushing: &index)
    }
    
    /// Returns the first element by pushing the given `index`.
    @inlinable public static func prefix1<Base: Collection>(
    _   base: Base, pushing index: inout Base.Index) -> Wide1 where Base.Element == High.Magnitude {
        defer{ base.formIndex(after: &index) }
        return High(bitPattern: base[index])
    }
    
    /// Returns the first two elements.
    @inlinable public static func prefix2<Base: Collection>(
    _   base: Base) -> Wide2 where Base.Element == High.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix2(base, pushing: &index)
    }
    
    /// Returns the first two elements by pushing the given `index`.
    @inlinable public static func prefix2<Base: Collection>(
    _   base: Base, pushing index: inout Base.Index) -> Wide2 where Base.Element == High.Magnitude {
        let result: Wide2
        result.low  = NBK.TBI.prefix1(base, pushing: &index)
        result.high = NBK.TBI.prefix1(base, pushing: &index)
        return result as Wide2
    }
    
    /// Returns the first three elements.
    @inlinable public static func prefix3<Base: Collection>(
    _   base: Base) -> Wide3 where Base.Element == High.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix3(base, pushing: &index)
    }
    
    /// Returns the first three elements by pushing the given `index`.
    @inlinable public static func prefix3<Base: Collection>(
    _   base: Base, pushing index: inout Base.Index) -> Wide3 where Base.Element == High.Magnitude {
        let result: Wide3
        result.low  = NBK.TBI.prefix1(base, pushing: &index)
        result.mid  = NBK.TBI.prefix1(base, pushing: &index)
        result.high = NBK.TBI.prefix1(base, pushing: &index)
        return result as Wide3
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns the last element.
    @inlinable public static func suffix1<Base: BidirectionalCollection>(
    _   base: Base) -> Wide1 where Base.Element == High.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix1(base, pulling: &index)
    }
    
    /// Returns the last element by pulling the given `index`.
    @inlinable public static func suffix1<Base: BidirectionalCollection>(
    _   base: Base, pulling index: inout Base.Index) -> Wide1 where Base.Element == High.Magnitude {
        base.formIndex(before: &index)
        return High(bitPattern: base[index])
    }
    
    /// Returns the last two elements.
    @inlinable public static func suffix2<Base: BidirectionalCollection>(
    _   base: Base) -> Wide2 where Base.Element == High.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix2(base, pulling: &index)
    }
    
    /// Returns the last two elements by pulling the given `index`.
    @inlinable public static func suffix2<Base: BidirectionalCollection>(
    _   base: Base, pulling index: inout Base.Index) -> Wide2 where Base.Element == High.Magnitude {
        let result: Wide2
        result.high = NBK.TBI.suffix1(base, pulling: &index)
        result.low  = NBK.TBI.suffix1(base, pulling: &index)
        return result as Wide2
    }
    
    /// Returns the last three elements.
    @inlinable public static func suffix3<Base: BidirectionalCollection>(
    _   base: Base) -> Wide3 where Base.Element == High.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix3(base, pulling: &index)
    }
    
    /// Returns the last three elements by pulling the given `index`.
    @inlinable public static func suffix3<Base: BidirectionalCollection>(
    _   base: Base, pulling index: inout Base.Index) -> Wide3 where Base.Element == High.Magnitude {
        let result: Wide3
        result.high = NBK.TBI.suffix1(base, pulling: &index)
        result.mid  = NBK.TBI.suffix1(base, pulling: &index)
        result.low  = NBK.TBI.suffix1(base, pulling: &index)
        return result as Wide3
    }
}
