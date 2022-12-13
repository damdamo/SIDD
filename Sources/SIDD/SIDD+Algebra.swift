extension SIDDFactory {

  public func contains<S>(_ pointer: SIDD<Key>.Pointer, _ member: S) -> Bool
    where S: Sequence, S.Element == Key
  {
    var it = member.makeIterator()

    var currentPointer = pointer
    var key = it.next()

    while key != nil && !isTerminal(currentPointer) {
      if currentPointer.pointee.key < key! {
        currentPointer = currentPointer.pointee.skip
      } else if currentPointer.pointee.key == key! {
        currentPointer = currentPointer.pointee.take
        key = it.next()
      } else {
        currentPointer = currentPointer.pointee.skip
      }
    }

    return key == nil && skipMost(currentPointer) == onePointer
  }

  /// Returns the union of two SIDDs.
  public func union(_ lhs: SIDD<Key>.Pointer, _ rhs: SIDD<Key>.Pointer) -> SIDD<Key>.Pointer {
    // Check for trivial cases.
    if lhs == zeroPointer || lhs == rhs {
      return rhs
    } else if rhs == zeroPointer {
      return lhs
    }

    // Query the cache.
    let cacheKey = lhs < rhs ? [lhs, rhs] : [rhs, lhs]
    if let pointer = cache.union[cacheKey] {
      return pointer
    }

    // Compute the union of `lhs` with `rhs`.
    let result: SIDD<Key>.Pointer
    if lhs == onePointer {
      result = node(
        key: rhs.pointee.key,
        take: rhs.pointee.take,
        skip: union(lhs, rhs.pointee.skip),
        isIncluded: rhs.pointee.isIncluded)
    } else if rhs == onePointer {
      result = node(
        key: lhs.pointee.key,
        take: lhs.pointee.take,
        skip: union(rhs, lhs.pointee.skip),
        isIncluded: lhs.pointee.isIncluded)
    } else if lhs.pointee.key < rhs.pointee.key {
      result = node(
        key: lhs.pointee.key,
        take: lhs.pointee.take,
        skip: union(lhs.pointee.skip, rhs),
        isIncluded: lhs.pointee.isIncluded)
    } else if lhs.pointee.key == rhs.pointee.key {
      result = node(
        key: lhs.pointee.key,
        take: unionTau(lhs.pointee.take, rhs.pointee.take),
        skip: union(lhs.pointee.skip, rhs.pointee.skip),
        isIncluded: lhs.pointee.isIncluded || rhs.pointee.isIncluded)
    } else {
      result = node(
        key: rhs.pointee.key,
        take: rhs.pointee.take,
        skip: union(rhs.pointee.skip, lhs),
        isIncluded: rhs.pointee.isIncluded)
    }

    cache.union[cacheKey] = result
    return result
//    return self.zeroPointer
  }
  
  public func unionTau(_ lhs: SIDD<Key>.Pointer, _ rhs: SIDD<Key>.Pointer) -> SIDD<Key>.Pointer {
    // Check for trivial cases.
    if lhs == zeroPointer || lhs == rhs {
      return rhs
    } else if rhs == zeroPointer {
      return lhs
    }

    // Query the cache.
    let cacheKey = lhs < rhs ? [lhs, rhs] : [rhs, lhs]
    if let pointer = cache.union[cacheKey] {
      return pointer
    }

    // Compute the union of `lhs` with `rhs`.
    let result: SIDD<Key>.Pointer
    
    if lhs.pointee.key < rhs.pointee.key {
      result = node(
        key: lhs.pointee.key,
        take: unionTau(lhs.pointee.take, rhs),
        skip: lhs.pointee.skip,
        isIncluded: lhs.pointee.isIncluded)
    } else if lhs.pointee.key == rhs.pointee.key {
      result = node(
        key: lhs.pointee.key,
        take: unionTau(lhs.pointee.take, rhs.pointee.take),
        skip: union(lhs.pointee.skip, rhs.pointee.skip),
        isIncluded: lhs.pointee.isIncluded || rhs.pointee.isIncluded)
    } else {
      result = node(
        key: rhs.pointee.key,
        take: unionTau(rhs.pointee.take, lhs),
        skip: rhs.pointee.skip,
        isIncluded: rhs.pointee.isIncluded)
    }

    cache.union[cacheKey] = result
    return result
    
  }

  /// Returns the intersection of two SIDDs.
  public func intersection(
    _ lhs: SIDD<Key>.Pointer,
    _ rhs: SIDD<Key>.Pointer
  ) -> SIDD<Key>.Pointer
  {
//    // Check for trivial cases.
//    if lhs == zeroPointer || lhs == rhs {
//      return lhs
//    } else if rhs == zeroPointer {
//      return rhs
//    }
//
//    // Query the cache.
//    let cacheKey = lhs < rhs ? [lhs, rhs] : [rhs, lhs]
//    if let pointer = cache.intersection[cacheKey] {
//      return pointer
//    }
//
//    // Compute the intersection of `lhs` with `rhs`.
//    let result: SIDD<Key>.Pointer
//    if lhs == onePointer {
//      result = skipMost(rhs)
//    } else if rhs == onePointer {
//      result = skipMost(lhs)
//    } else if lhs.pointee.key < rhs.pointee.key {
//      result = intersection(lhs.pointee.skip, rhs)
//    } else if lhs.pointee.key == rhs.pointee.key {
//      result = node(
//        key: lhs.pointee.key,
//        take: intersection(lhs.pointee.take, rhs.pointee.take),
//        skip: intersection(lhs.pointee.skip, rhs.pointee.skip))
//    } else {
//      result = intersection(lhs, rhs.pointee.skip)
//    }
//
//    cache.intersection[cacheKey] = result
//    return result
    return self.zeroPointer

  }


  /// Returns the symmetric difference (a.k.a. disjunctive union) between two SIDDs.
  public func symmetricDifference(
    _ lhs: SIDD<Key>.Pointer,
    _ rhs: SIDD<Key>.Pointer
  ) -> SIDD<Key>.Pointer
  {
//    // Check for trivial cases.
//    if lhs == zeroPointer {
//      return rhs
//    } else if rhs == zeroPointer {
//      return lhs
//    } else if lhs == rhs {
//      return zeroPointer
//    }
//
//    // Query the cache.
//    let cacheKey = lhs < rhs ? [lhs, rhs] : [rhs, lhs]
//    if let pointer = cache.symmetricDifference[cacheKey] {
//      return pointer
//    }
//
//    // Compute the symmetric difference between `lhs` and `rhs`.
//    let result: SIDD<Key>.Pointer
//    if lhs == onePointer {
//      result = node(
//        key: rhs.pointee.key,
//        take: rhs.pointee.take,
//        skip: symmetricDifference(lhs, rhs.pointee.skip))
//    } else if rhs == onePointer {
//      result = node(
//        key: lhs.pointee.key,
//        take: lhs.pointee.take,
//        skip: symmetricDifference(lhs.pointee.skip, rhs))
//    } else if lhs.pointee.key < rhs.pointee.key {
//      result = node(
//        key: lhs.pointee.key,
//        take: lhs.pointee.take,
//        skip: symmetricDifference(lhs.pointee.skip, rhs))
//    } else if lhs.pointee.key == lhs.pointee.key {
//      result = node(
//        key: lhs.pointee.key,
//        take: symmetricDifference(lhs.pointee.take, rhs.pointee.take),
//        skip: symmetricDifference(lhs.pointee.skip, rhs.pointee.skip))
//    } else {
//      result = node(
//        key: rhs.pointee.key,
//        take: rhs.pointee.take,
//        skip: symmetricDifference(lhs, rhs.pointee.skip))
//    }
//
//    cache.symmetricDifference[cacheKey] = result
//    return result
    return self.zeroPointer

  }

  /// Returns `lhs` subtracting `rhs`.
  public func subtraction(
    _ lhs: SIDD<Key>.Pointer,
    _ rhs: SIDD<Key>.Pointer
  ) -> SIDD<Key>.Pointer
  {
//    // Check for trivial cases.
//    if lhs == zeroPointer || rhs == zeroPointer {
//      return lhs
//    } else if lhs == rhs {
//      return zeroPointer
//    }
//
//    // Query the cache.
//    let cacheKey = lhs < rhs ? [lhs, rhs] : [rhs, lhs]
//    if let pointer = cache.subtraction[cacheKey] {
//      return pointer
//    }
//
//    // Compute `lhs` subtracting `rhs`.
//    let result: SIDD<Key>.Pointer
//    if lhs == onePointer {
//      result = skipMost(rhs) == zeroPointer ? lhs : zeroPointer
//    } else if rhs == onePointer {
//      result = node(
//        key: lhs.pointee.key,
//        take: lhs.pointee.take,
//        skip: subtraction(lhs.pointee.skip, rhs))
//    } else if lhs.pointee.key < rhs.pointee.key {
//      result = node(
//        key: lhs.pointee.key,
//        take: lhs.pointee.take,
//        skip: subtraction(lhs.pointee.skip, rhs))
//    } else if lhs.pointee.key == rhs.pointee.key {
//      result = node(
//        key: lhs.pointee.key,
//        take: subtraction(lhs.pointee.take, rhs.pointee.take),
//        skip: subtraction(lhs.pointee.skip, rhs.pointee.skip))
//    } else {
//      result = subtraction(lhs, rhs.pointee.skip)
//    }
//
//    cache.subtraction[cacheKey] = result
//    return result
    return self.zeroPointer

  }

  /// Returns the terminal obtained by following the skip branch of the given SIDD.
  public func skipMost(_ pointer: SIDD<Key>.Pointer) -> SIDD<Key>.Pointer {
    var result = pointer
    while result != zeroPointer && result != onePointer {
      result = result.pointee.skip
    }
    return result
  }

}
