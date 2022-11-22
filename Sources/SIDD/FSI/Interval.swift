/// Definition of an interval
/// An interval is either empty or a composition of two bound values and two bound symbols to include or exclude the bound value.
/// It could be visualized as: [a,b], [a,b), (a,b], (a,b)
public struct Interval <K: Comparable & Hashable>: Hashable {  
  
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
  func intersection(_ i: Interval<K>) -> Interval<K>? {
    var k1: K
    var k2: K
    switch (self.intvl, i.intvl) {
    case (_, .empty):
      return i
    case (.empty, _):
      return self
    case (.intvl(let l1, let a, let b, let r1), .intvl(let l2, let c, let d, let r2)):
      var lbracket: Lbracket
      var rbracket: Rbracket
      if b < c {
        return Interval(intvl: .empty)
      } else if a <= c && b >= c && b <= d {
        k1 = c
        k2 = b
        if a == c {
          lbracket = Interval<K>.strongLeftExclusion(l1: l1, l2: l2)
        } else {
          lbracket = l2
        }
        if b == d {
          rbracket = Interval<K>.strongRightExclusion(r1: r1, r2: r2)
        } else {
          rbracket = r1
        }
      } else if a <= c && b > d {
        k1 = c
        k2 = d
        if a == c {
          lbracket = Interval<K>.strongLeftExclusion(l1: l1, l2: l2)
        } else {
          lbracket = l2
        }
        rbracket = r2
      } else {
        return i.intersection(self)
      }
      return Interval(intvl: .intvl(
        lbracket: lbracket,
        a: k1,
        b: k2,
        rbracket: rbracket)
      )
    default:
      return nil
    }

  }
  
  /// Union between two intervals
  /// - Parameters:
  ///   - i:  Interval to merge
  /// - Returns: The result of the union, which is a set of intervals
  func union(_ i: Interval) -> SetIntervals<K>? {
    switch (self.intvl, i.intvl) {
    case (_, .empty):
      return SetIntervals(setIntervals: [self])
    case (.empty, _):
      return SetIntervals(setIntervals: [i])
    case (.intvl(let l1, let a, let b, let r1), .intvl(let l2, let c, let d, let r2)):
      if let r = self.intersection(i)?.isEmpty() {
        if r == true {
          return SetIntervals(setIntervals: [self,i])
        }
      }
      var lb: Lbracket
      var rb: Rbracket
      if a <= c && b >= c && b < d {
        if a == c {
          lb = Interval<K>.strongLeftInclusion(l1: l1, l2: l2)
        } else {
          lb = l1
        }
        return SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: lb, a: a, b: d, rbracket: r2))])
      } else if a <= c && b >= d {
        if a == c {
          lb = Interval<K>.strongLeftInclusion(l1: l1, l2: l2)
        } else {
          lb = l1
        }
        if b == d {
          rb = Interval<K>.strongRightInclusion(r1: r1, r2: r2)
        } else {
          rb = r1
        }
        return SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: lb, a: a, b: b, rbracket: rb))])
      } else {
        return i.union(self)
      }
    default:
      return nil
    }
  }
  
  /// Difference between two intervals
  /// - Parameters:
  ///   - i:  Interval to subtract
  /// - Returns: The result of the subtraction, which is a set of intervals
  func difference(_ i: Interval) -> SetIntervals<K>? {
    if self == i {
      return SetIntervals(setIntervals: [Interval(intvl: .empty)])
    }
    
    switch (self.intvl, i.intvl) {
    case (_, .empty):
      return SetIntervals(setIntervals: [self])
    case (.empty, _):
      return SetIntervals(setIntervals: [self])
    case (.intvl(let l1, let a, let b, let r1), .intvl(let l2, let c, let d, let r2)):
      if let r = self.intersection(i)?.isEmpty() {
        if r == true {
          return SetIntervals(setIntervals: [self])
        }
      }
      var lb: Lbracket
      var rb: Rbracket
      if a < c && b >= c && b <= d {
        switch l2 {
        case .i:
          rb = .e
        case .e:
          rb = .i
        }
        lb = l1
        return SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: lb, a: a, b: c, rbracket: rb))])
      } else if a < c && b > d {
        switch l2 {
        case .i:
          rb = .e
        case .e:
          rb = .i
        }
        switch r2 {
        case .i:
          lb = .e
        case .e:
          lb = .i
        }
        return SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: l1, a: a, b: c, rbracket: rb)), Interval(intvl: .intvl(lbracket: lb, a: d, b: b, rbracket: r1))])
      } else if a >= c && d >= a && b > d {
        switch r2 {
        case .i:
          lb = .e
        case .e:
          lb = .i
        }
        rb = r1
        return SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: lb, a: d, b: b, rbracket: rb))])
      } else {
        return SetIntervals(setIntervals: [])
      }
      
    default:
      return nil
    }
  }
  
  /// Filter "lesser than" by a value k. It keeps only values that are lower than a key.
  /// - Parameter k: The bound limit
  /// - Returns: The filtered interval
  func filterLt(k: K) -> Interval? {
    switch self.intvl {
    case .empty:
      return self
    case .intvl(lbracket: let lb, a: let a, b: let b, rbracket: _):
      if k <= a {
        return Interval(intvl: .empty)
      } else if k > a && k <= b {
        return Interval(intvl: .intvl(lbracket: lb, a: a, b: k, rbracket: .e))
      } else {
        return self
      }
    default:
      return nil
    }
  }
  
  /// Filter "greater than or equal" by a value k. It keeps only values that are greater or equal than a key.
  /// - Parameter k: The bound limit
  /// - Returns: The filtered interval
  func filterGeq(k: K) -> Interval? {
    switch self.intvl {
    case .empty:
      return self
    case .intvl(lbracket: _, a: let a, b: let b, rbracket: let rb):
      if k <= a {
        return self
      } else if k > a && k <= b {
        return Interval(intvl: .intvl(lbracket: .i, a: k, b: b, rbracket: rb))
      } else {
        return Interval(intvl: .empty)
      }
    default:
      return nil
    }
  }
  
  /// Return whether an interval is included in another one
  /// - Parameter i: The interval that contains or not self
  /// - Returns: True if the interval is containeid, false otherwise
  func isIncludedIn(i: Interval) -> Bool {
    return (self.intersection(i) == self)
  }
  
  
  /// Return if the interval is the empty interval
  /// - Returns: True if empty, false otherwise
  func isEmpty() -> Bool {
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
  
  /// Switch [ by ( and [ by (
  static func switchLeftParenthesis(l: Lbracket) -> Lbracket {
    switch l {
    case .i:
      return .e
    case .e:
      return .i
    }
  }
  
  /// Switch ] by ) and ) by ]
  static func switchRightParenthesis(r: Rbracket) -> Rbracket {
    switch r {
    case .i:
      return .e
    case .e:
      return .i
    }
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(intvl)
  }
  
}


extension Interval where K: Countable {

  /// Canonization of an interval, to get only square brackets. Intervals of the form (a,b), [a,b) and (a,b] can be rewritten into a [a',b'] form.
  /// For instance, (a,b) = [next(a), pre(b)]
  /// - Returns: The canonized interval
  func canonized() -> Interval? {
    switch self.intvl {
    case .empty:
      return self
    case .intvl(lbracket: let lb, a: let a, b: let b, rbracket: let rb):
      if lb == .e || rb == .e {
        var a1: K
        var b1: K
        if lb == .e {
          a1 = a.next() as! K
        } else {
          a1 = a
        }
        if rb == .e {
          b1 = b.pre() as! K
        } else {
          b1 = b
        }
        return Interval(intvl: .intvl(lbracket: .i, a: a1, b: b1, rbracket: .i))
      } else {
        return self
      }
    default:
      return nil
    }
  }
  
}
