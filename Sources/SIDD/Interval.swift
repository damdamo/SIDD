/// Definition of an interval
public struct Interval <K: Comparable & Hashable>: Hashable {
//  public static func < (lhs: Interval<K>, rhs: Interval<K>) -> Bool {
//    switch (lhs.intvl, rhs.intvl) {
//    case (_, .empty):
//      return false
//    case (.empty, _):
//      return true
//    case (.intvl(lbracket: let l1, a: let a1, b: let b1, rbracket: let r1), .intvl(lbracket: let l2, a: let a2, b: let b2, rbracket: let r2)):
//      return true
//    default:
//      return false
//    }
//  }
  
  
  let intvl: Intvl<K>?
  
  /// Check that in <a,b>, a < b and if a = b, then only [a,a] is possible
  init(intvl: Intvl<K>) {
    switch intvl {
    case .empty:
      self.intvl = intvl
    case .intvl(lbracket: let l, a: let a, b: let b, rbracket: let r):
      if a <= b {
        if a == b {
          switch (l,r) {
          case (.i, .i):
            self.intvl = intvl
          default:
            self.intvl = Intvl.empty
          }
        } else {
          self.intvl = intvl
        }
      } else {
        self.intvl = nil
      }
    }
  }
    
  /// Left bracket
  enum Lbracket: Hashable {
    // i = [
    case i
    // e = (
    case e
  }
  
  /// Right bracket
  enum Rbracket: Hashable {
    // i = ]
    case i
    // e = )
    case e
  }
  
  /// Interval writing
  enum Intvl<K: Comparable & Hashable>: Hashable {
    // Ø interval
    case empty
    // Non empty interval of the form: [a,b] or [a,b) or (a,b] or (a,b)
    case intvl(lbracket: Lbracket, a: K, b: K, rbracket: Rbracket)
  }
  
  /// Intersection between two intervals
  /// - Parameters:
  ///   - i:  Interval to intersect
  /// - Returns: The result of the intersection
  public func intersection(_ i: Interval<K>) -> Interval<K>? {
    var k1: K
    var k2: K
    switch (self.intvl, i.intvl) {
    case (_, .empty):
      return i
    case (.empty, _):
      return self
    case (.intvl(let l1, let a, let b, let r1), .intvl(let l2, let c, let d, let r2)):
      if b < c {
        return Interval(intvl: .empty)
      } else if a <= c && b >= c && b <= d {
        k1 = c
        k2 = b
      } else if a <= c && b > d {
        k1 = c
        k2 = d
      } else {
        return i.intersection(self)
      }
      return Interval(intvl: .intvl(
        lbracket: Interval<K>.strongLeftExclusion(l1: l1, l2: l2),
        a: k1,
        b: k2,
        rbracket: Interval<K>.strongRightExclusion(r1: r1, r2: r2))
      )
    default:
      return nil
    }

  }
  
  /// Union between two intervals
  /// - Parameters:
  ///   - i:  Interval to merge
  /// - Returns: The result of the union, that is a set of intervals
//  public func union(_ i: Interval) -> SetIntervals<K> {
//
//    var k1: K
//    var k2: K
//
//    if let r = self.intersection(i)?.isEmpty() {
//      if r == true {
//        return SetIntervals(setIntervals: [self,i])
//      }
//    }
//
//    switch (self.intvl, i.intvl) {
//    case (_, .empty):
//      return SetIntervals(setIntervals: [self])
//    case (.empty, _):
//      return SetIntervals(setIntervals: [i])
//    case (.intvl(let l1, let a, let b, let r1), .intvl(let l2, let c, let d, let r2)):
//      if a <= c && b >= c && b < d {
//        k1 = a
//        k2 = d
//      } else if a <= c && b >= d {
//        k1 = a
//        k2 = b
//      } else {
//        return i.union(self)
//      }
//      let (l,r) = Interval<K>.strongInclusion(l1: l1,r1: r1, l2: l2, r2: r2)
//
//      return Interval(intvl: .intvl(lbracket: l, a: k1, b: k2, rbracket: r))
//
//    default:
//      return nil
//    }
//  }
  
  public func isEmpty() -> Bool {
    if self.intvl == .empty {
      return true
    }
    return false
  }
  
  /// Checks the left brackets and returns the merging of these where the inclusion take precedence.
  /// E.g.: [,( -> [
  static func strongLeftInclusion(l1: Lbracket, l2: Lbracket) -> Lbracket {
    switch (l1, l2) {
    case (.i,_):
      return .i
    case (_, .i):
      return .i
    default:
      return .e
    }
  }
  
  /// Checks the right brackets and returns the merging of these where the inclusion take precedence.
  /// E.g.: [,( -> [
  static func strongRightInclusion(r1: Rbracket, r2: Rbracket) -> Rbracket {
    switch (r1, r2) {
    case (.i,_):
      return .i
    case (_, .i):
      return .i
    default:
      return .e
    }
  }
  
  
  /// Checks the left brackets and returns the merging of these where the exclusion take precedence.
  /// E.g.: [,( -> (
  static func strongLeftExclusion(l1: Lbracket, l2: Lbracket) -> Lbracket {
    switch (l1, l2) {
    case (.e,_):
      return .e
    case (_, .e):
      return .e
    default:
      return .i
    }
  }
  
  /// Checks the right brackets and returns the merging of these where the exclusion take precedence.
  /// E.g.: [,( -> (
  static func strongRightExclusion(r1: Rbracket, r2: Rbracket) -> Rbracket {
    switch (r1, r2) {
    case (.e,_):
      return .e
    case (_, .e):
      return .e
    default:
      return .i
    }
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(intvl)
  }
  
}
