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
  
  public func hash(into hasher: inout Hasher) {
      hasher.combine(setIntervals)
  }
  
}
