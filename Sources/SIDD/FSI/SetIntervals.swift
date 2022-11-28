/// A structure that contains a set of intervals with additional constraints and operations to work on these intervals.
public struct SetIntervals<K: Comparable & Hashable>: Hashable {
  
  // Set of intervals
  let setIntervals: Set<Interval<K>>?
  
  /// Check that there is no intersection between each interval of a set
  public init(setIntervals: Set<Interval<K>>) {
    var cond: Bool = true
    for i1 in setIntervals {
      for i2 in setIntervals {
        if let r = i1.intersection(i2) {
          if r.intvl != .empty {
            if i1 != i2 {
              cond = false
              break
            }
          }
        }
      }
      if cond == false {
        break
      }
    }
      
    if cond {
      if setIntervals.contains(Interval(intvl: .empty)) {
        var s = setIntervals
        s.remove(Interval(intvl: .empty))
        self.setIntervals = s
      } else {
        self.setIntervals = setIntervals
      }
    } else {
      self.setIntervals = nil
    }

  }
  
  /// Union between two sets of intervals
  /// - Parameters:
  ///   - s:  Set of intervals to merge
  /// - Returns: The result of the union
  func union(_ s: SetIntervals) -> SetIntervals? {
    switch (self.setIntervals, s.setIntervals) {
    case ([], _):
      return s
    case (_, []):
      return self
    case (let s1p, let s2p):
      if let s1 = s1p, let s2 = s2p {
        // Construct a dictionnary where the key is an interval from the left, and values are all the intervals (from right set) related to this key. However, once a value is added for a key, it is removed from s2NotShared. Thus, the same right interval cannot be related to different left intervals.
        var dicShareIntervals: [Interval<K>: Set<Interval<K>>] = [:]
        // s2Not Shared will keep only intervals that are not shared between both sets
        var s2NotShared = s2
        for i1 in s1 {
          dicShareIntervals[i1] = []
          for i2 in s2NotShared {
            if !i1.intersection(i2)!.isEmpty() {
              dicShareIntervals[i1]!.insert(i2)
              s2NotShared.remove(i2)
            }
          }
        }
        
        // Apply the union between the key and all of its values
        var mergeIntervals: Set<Interval<K>> = []
        for (key, value) in dicShareIntervals {
          var temp: Interval<K> = key
          for i in value {
            temp = (temp.union(i))!.setIntervals!.first!
          }
          mergeIntervals.insert(temp)
        }
        
        // Merge all got intervals from mergeIntervals
        var unionMergeIntervals: SetIntervals = SetIntervals(setIntervals: [])
        for i in mergeIntervals {
          unionMergeIntervals = unionMergeIntervals.union(SetIntervals(setIntervals: [i]))!
        }
                
        return SetIntervals(setIntervals: s2NotShared.union(unionMergeIntervals.setIntervals!))
      } else {
        return nil
      }
    }  }
  
  /// Addition of an interval with a set of intervals.
  /// A particular case from the union between two sets of intervals.
  /// - Parameters:
  ///   - i:  The interval to add
  /// - Returns: The result of the addition
  func add(_ i: Interval<K>) -> SetIntervals? {
    return self.union(SetIntervals(setIntervals: [i]))
  }
  
  /// Intersection between two sets of intervals.
  /// E.g.: {[1,5], [10,15]} ∩ {[4,13]} = {[4,5], [10,13]}
  /// - Parameters:
  ///   - s:  Set of intervals to intersect
  /// - Returns: The result of the intersection
  func intersection(_ s: SetIntervals) -> SetIntervals? {
    switch (self.setIntervals, s.setIntervals) {
    case ([], _):
      return self
    case (_, []):
      return s
    case (let s1p, let s2p):
      if let s1 = s1p, let s2 = s2p {
        // Construct a dictionnary where the key is an interval from the left, and values are all the intervals (from right set) related to this key. However, once a value is added for a key, it is removed from s2NotShared. Thus, the same right interval cannot be related to different left intervals.
        var dicShareIntervals: [Interval<K>: Set<Interval<K>>] = [:]
        for i1 in s1 {
          dicShareIntervals[i1] = []
          for i2 in s2 {
            if !i1.intersection(i2)!.isEmpty() {
              dicShareIntervals[i1]!.insert(i2)
            }
          }
        }
                
        // Apply the intersection between the key and all of its values
        var mergeIntervals: Set<Interval<K>> = []
        for (key, value) in dicShareIntervals {
          for i in value {
            mergeIntervals.insert(key.intersection(i)!)
          }
        }
                
        return SetIntervals(setIntervals: mergeIntervals)
      } else {
        return nil
      }
    }  }
  
  /// Difference between two sets of intervals.
  /// E.g.: {[1,5], [10,15]} \ {[4,13]} = {[1,4), (13,15]}
  /// - Parameters:
  ///   - s:  Set of intervals to subtract
  /// - Returns: The result of the difference
  func difference(_ s: SetIntervals) -> SetIntervals? {
    if self == s {
      return SetIntervals(setIntervals: [])
    }
    
    switch (self.setIntervals, s.setIntervals) {
    case ([], _):
      return self
    case (_, []):
      return self
    case (let s1p, let s2p):
      if let s1 = s1p, let s2 = s2p {
        // Construct a dictionnary where the key is an interval from the left, and values are all the intervals (from right set) related to this key. However, once a value is added for a key, it is removed from s2NotShared. Thus, the same right interval cannot be related to different left intervals.
        var dicShareIntervals: [Interval<K>: Set<Interval<K>>] = [:]
        for i1 in s1 {
          dicShareIntervals[i1] = []
          for i2 in s2 {
            if !i1.intersection(i2)!.isEmpty() {
              dicShareIntervals[i1]!.insert(i2)
            }
          }
        }

        // Apply the difference between the key and all of its values
        var set: Set<Interval<K>>
        var mergeIntervals: SetIntervals = SetIntervals(setIntervals: [])
        for (key, intervals) in dicShareIntervals {
          // For a key, we have to subtract all intervals of the set "intervals".
          // We take the first one (no matter which one) and we apply the difference on key
          // Then, the result is a set of intervals, so we reapply the set difference on this new result
          if let interval = intervals.first {
            set = intervals
            set.remove(interval)
            mergeIntervals = mergeIntervals.union(key.difference(interval)!.difference(SetIntervals(setIntervals: set))!)!
          } else {
            mergeIntervals = mergeIntervals.union(SetIntervals(setIntervals: [key]))!
          }
        }
        return mergeIntervals
      } else {
        return nil
      }
    }
  }
  
  /// Subtract an interval from a set of intervals.
  /// A particular case from the difference between two sets of intervals.
  /// - Parameters:
  ///   - i:  The interval to subtract
  /// - Returns: The result of the subtraction
  func sub(_ i: Interval<K>) -> SetIntervals? {
    return self.difference(SetIntervals(setIntervals: [i]))
  }
  
  public func hash(into hasher: inout Hasher) {
      hasher.combine(setIntervals)
  }
  
  
  /// Filter "lesser than" by a value k. It keeps only values that are lower than a key for each interval in a set.
  /// - Parameter k: The bound limit
  /// - Returns: The filtered set of intervals
  func filterLt(_ k: K) -> SetIntervals? {
    if let setIntervals = self.setIntervals {
      let newIntervals: Set<Interval<K>> = Set(setIntervals.map({$0.filterLt(k)!}))
      return SetIntervals(setIntervals: newIntervals)
    }
    return nil
  }
  
  /// Filter "greater than or equal" by a value k. It keeps only values that are greater or equal than a key for each interval in a set.
  /// - Parameter k: The bound limit
  /// - Returns: The filtered set of intervals
  func filterGeq(_ k: K) -> SetIntervals? {
    if let setIntervals = self.setIntervals {
      let newIntervals: Set<Interval<K>> = Set(setIntervals.map({$0.filterGeq(k)!}))
      return SetIntervals(setIntervals: newIntervals)
    }
    return nil
  }
  
  /// Checks if all intervals of the left sets are included in the right set
  /// - Parameter s: The set of intervals to look at
  /// - Returns: True if all intervals are included, false otherwise
  func isIncludedIn(_ s: SetIntervals) -> Bool {
    if let s1 = self.setIntervals, let s2 = s.setIntervals {
      if s1 == [] {
        return true
      } else if s2 == [] {
        return false
      }
      return s1.allSatisfy({(i1: Interval<K>) -> Bool in
        for i2 in s2 {
          if i1.isIncludedIn(i: i2) {
            return true
          }
        }
        return false
      })
    }
    return false
  }
  
  /// Compute the number of element in the set
  /// - Returns: The number of element in the set
  func count() -> Int? {
    return self.setIntervals?.count
  }
  
}


extension SetIntervals where K: Countable {
  
  /// Canonized a set of intervals for countable ones. The goal is to avoid sets of interval of the form: {[a,b], [next(b), c]} = {[a,c]}
  /// - Parameter canonizedIntervals: A condition to avoid to re canonize the intervals multiple times. False by default, to apply the canonization a single time.
  /// - Returns:The canonized set of intervals
  func canonized(canonizedIntervals: Bool = false) -> SetIntervals<K>? {
    
    if self.setIntervals == [] {
      return self
    }
    
    if let setIntervals = setIntervals {
      let setCanonized: SetIntervals
      if !canonizedIntervals {
        setCanonized = SetIntervals(setIntervals: Set(setIntervals.map({$0.canonized()!})))
      } else {
        setCanonized = self
      }
      
      var newSetIntervals = SetIntervals(setIntervals: [])
      let interval = setCanonized.setIntervals!.first!
      let s = setCanonized.sub(interval)!
      
      switch interval.intvl {
      case .intvl(lbracket: let lb1, a: let a1, b: let b1, rbracket: let rb1):
        for i in s.setIntervals! {
          switch i.intvl {
          case .intvl(lbracket: let lb2, a: let a2, b: let b2, rbracket: let rb2):
            if rb1 == .i && lb2 == .i && b1.next() as! K == a2 {
              newSetIntervals = newSetIntervals.union(
                SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: lb1, a: a1, b: b2, rbracket: rb2))])
              )!
              return newSetIntervals.union(s.sub(i)!)!.canonized(canonizedIntervals: true)
            } else if lb1 == .i && rb2 == .i && a1 == b2.next() as! K {
              newSetIntervals = newSetIntervals.union(
                SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: lb2, a: a2, b: b1, rbracket: rb1))])
              )!
              return newSetIntervals.union(s.sub(i)!)!.canonized(canonizedIntervals: true)
            }
          default:
            continue
          }
        }
      default:
        fatalError("Not possible")
      }
      
      return setCanonized
      
    }
    return nil
  }
  
}
