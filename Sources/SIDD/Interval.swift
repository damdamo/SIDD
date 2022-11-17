// TODO: Change Interval enum into a structure, to give constraints to init, a < b, and no (a,a), (a,a] and [a,a)


// Left bracket
public enum Lbracket {
  // i = [
  case i
  // e = (
  case e
}

// Right bracket
public enum Rbracket {
  // i = ]
  case i
  // e = )
  case e
}

public enum Interval<K: Comparable>: Equatable {
  // Ø interval
  case empty
  // Non empty interval of the form: [a,b] or [a,b) or (a,b] or (a,b)
  case intvl(lbracket: Lbracket, a: K, b: K, rbracket: Rbracket)
  
  /// Intersection between two intervals
  /// - Parameters:
  ///   - i1: First interval
  ///   - i2: Second interval
  /// - Returns: The result of the intersection
  public static func intersection(i1: Interval, i2: Interval) -> Interval {
    var k1: K
    var k2: K
    switch (i1, i2) {
    case (_, .empty):
      return i1
    case (.empty, _):
      return i2
    case (.intvl(let l1, let a, let b, let r1), .intvl(let l2, let c, let d, let r2)):
      if b < c {
        return .empty
      } else if a <= c && b >= c && b <= d {
        k1 = c
        k2 = b
      } else if a <= c && b > d {
        k1 = c
        k2 = d
      } else {
        return intersection(i1: i2, i2: i1)
      }
      let (l,r) = strongExclusion(l1: l1,r1: r1, l2: l2, r2: r2)
      
      return .intvl(lbracket: l, a: k1, b: k2, rbracket: r)
    }
  }
  
  // Checks the left and right brackets and returns the merging of these where the inclusion take precedence.
  // E.g.: [,( -> [
  private static func strongInclusion(l1: Lbracket,r1: Rbracket, l2: Lbracket, r2: Rbracket) -> (Lbracket, Rbracket) {
    var l: Lbracket
    var r: Rbracket
    switch (l1, l2) {
    case (.i,_):
      l = .i
    case (_, .i):
      l = .i
    default:
      l = .e
    }
    switch (r1, r2) {
    case (.i,_):
      r = .i
    case (_, .i):
      r = .i
    default:
      r = .e
    }
    return (l,r)
  }
  
  // Checks the left and right brackets and returns the merging of these where the exclusion take precedence.
  // E.g.: [,( -> (
  private static func strongExclusion(l1: Lbracket,r1: Rbracket, l2: Lbracket, r2: Rbracket) -> (Lbracket, Rbracket) {
    var l: Lbracket
    var r: Rbracket
    switch (l1, l2) {
    case (.e,_):
      l = .e
    case (_, .e):
      l = .e
    default:
      l = .i
    }
    switch (r1, r2) {
    case (.e,_):
      r = .e
    case (_, .e):
      r = .e
    default:
      r = .i
    }
    return (l,r)
  }
  
}
