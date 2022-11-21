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
    return self.unionCore(s)
  }
  
  /// Intersection between two sets of intervals.
  /// E.g.: {[1,5], [10,15]} ∩ {[4,13]} = {[4,5], [10,13]}
  /// - Parameters:
  ///   - s:  Set of intervals to intersect
  /// - Returns: The result of the intersection
  func intersection(_ s: SetIntervals) -> SetIntervals? {
    return self.intersectionCore(s)
  }
  
  /// Union between two sets of intervals
  private func unionCore(_ s: SetIntervals) -> SetIntervals? {
    
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
          unionMergeIntervals = unionMergeIntervals.unionCore(SetIntervals(setIntervals: [i]))!
        }
                
        return SetIntervals(setIntervals: s2NotShared.union(unionMergeIntervals.setIntervals!))
      } else {
        return nil
      }
    }
    
  }
  
  /// Intersection between two sets of intervals
  private func intersectionCore(_ s: SetIntervals) -> SetIntervals? {
    
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
    }
    
  }
  
  public func hash(into hasher: inout Hasher) {
      hasher.combine(setIntervals)
  }
  
}


extension SetIntervals where K: Countable {
  func union(_ s: SetIntervals) -> SetIntervals<K>? {
    if let res = self.unionCore(s) {
      return canonized(res)
    }
    return nil
  }
  
  func intersection(_ s: SetIntervals) -> SetIntervals<K>? {
    if let res = self.intersectionCore(s) {
      return canonized(res)
    }
    return nil
  }
  
  // TODO: To complete
  func canonized(_ i: SetIntervals<K>) -> SetIntervals<K> {
    return i
  }
}
