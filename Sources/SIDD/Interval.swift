public struct Interval <K: Comparable>: Equatable {
  
  let intvl: Intvl<K>?
  
  // Check that in <a,b>, a < b and if a = b, then only [a,a] is possible
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
    
  // Left bracket
  enum Lbracket {
    // i = [
    case i
    // e = (
    case e
  }
  
  // Right bracket
  enum Rbracket {
    // i = ]
    case i
    // e = )
    case e
  }
  
  // Interval writing
  enum Intvl<K: Comparable>: Equatable {
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
      return self
    case (.empty, _):
      return i
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
      let (l,r) = Interval<K>.strongExclusion(l1: l1,r1: r1, l2: l2, r2: r2)
      
      return Interval(intvl: .intvl(lbracket: l, a: k1, b: k2, rbracket: r))
      
    default:
      return nil
    }

  }
  
  // Checks the left and right brackets and returns the merging of these where the inclusion take precedence.
  // E.g.: [,( -> [
  static func strongInclusion(l1: Lbracket,r1: Rbracket, l2: Lbracket, r2: Rbracket) -> (Lbracket, Rbracket) {
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
  static func strongExclusion(l1: Lbracket,r1: Rbracket, l2: Lbracket, r2: Rbracket) -> (Lbracket, Rbracket) {
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
