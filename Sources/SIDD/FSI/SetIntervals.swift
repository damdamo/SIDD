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
    
    // Return nil if there is a non empty intersection between two intervals
    self.setIntervals = cond ? setIntervals : nil
  }
  
  public func union(_ s: SetIntervals) -> SetIntervals? {
    return self.unionCore(s)
  }
  
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
  
  func canonized(_ i: SetIntervals<K>) -> SetIntervals<K> {
    return i
  }
}

//extension SetIntervals: Collection {
//  public typealias Index = Set<Interval<K>>.Index
////  typealias Element = DictionaryType.Element
//
//  // The upper and lower bounds of the collection, used in iterations
//  public var startIndex: Index { return setIntervals!.startIndex }
//  public var endIndex: Index { return setIntervals!.endIndex }
//
//  // Required subscript, based on a dictionary index
//  public subscript(index: Index) -> Iterator.Element {
//    get { return setIntervals?.contains(where: {$0.}) }
//  }
//
//  // Method that returns the next index when iterating
//  public func index(after i: Index) -> Index {
//    return setIntervals!.index(after: i)
//  }
//}
