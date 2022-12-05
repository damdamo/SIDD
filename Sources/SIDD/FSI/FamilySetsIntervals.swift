/// A structure that contains a family of sets of intervals with additional constraints and operations to work on these sets of intervals.
public struct FamilySetsIntervals<K: Comparable & Hashable>: Hashable {
 
  let familySetsIntervals: Set<SetIntervals<K>>
  
  /// Union of families of sets of intervals. This is similar to a set union.
  /// - Parameter f: The family to merge
  /// - Returns: The union of the two families
  func union(_ f: FamilySetsIntervals) -> FamilySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: self.familySetsIntervals.union(f.familySetsIntervals))
  }
  
  /// Intersection of families of sets of intervals. This is similar to a set intersection.
  /// - Parameter f: The family to intersect
  /// - Returns: The intersection of the two families
  func intersection(_ f: FamilySetsIntervals) -> FamilySetsIntervals {
    return FamilySetsIntervals(familySetsIntervals: self.familySetsIntervals.intersection(f.familySetsIntervals))
  }
  
  /// Difference of families of sets of intervals. This is similar to a set difference.
  /// - Parameter f: The family to subtract
  /// - Returns: The difference of the two sets
  func difference(_ f: FamilySetsIntervals) -> FamilySetsIntervals {
    return FamilySetsIntervals(familySetsIntervals: self.familySetsIntervals.subtracting(f.familySetsIntervals))
  }
  
  /// Inclusion of a family of sets of intervals inside another one. This is similar to a set inclusion.
  /// - Parameter f: The family to belong
  /// - Returns: True if all the sets from the left belong to the right family.
  func isIncludedIn(_ f: FamilySetsIntervals) -> Bool {
    return self.familySetsIntervals.isSubset(of: f.familySetsIntervals)
  }
  
  /// Addition an interval in a family. This is the recursive operation of the addition on all sets.
  /// - Parameter i: The interval to add
  /// - Returns: The new family with the added interval in all sets
  func add(_ i: Interval<K>) -> FamilySetsIntervals {
    return FamilySetsIntervals(familySetsIntervals: Set(self.familySetsIntervals.map({$0.add(i)})))
  }
  
  /// Subtraction of an interval in a family. This is the recursive operation of the subtraction on all sets.
  /// - Parameter i: The interval to subtract
  /// - Returns: The new family with the subtracted interval in all sets
  func sub(_ i: Interval<K>) -> FamilySetsIntervals {
    return FamilySetsIntervals(familySetsIntervals: Set(self.familySetsIntervals.map({$0.sub(i)})))
  }
  
  /// Filter all sets of the family by a value k to keep only values that are lower than k.
  /// - Parameter k: The filter value
  /// - Returns: The new family with the filtered intervals
  func filterLt(_ k: K) -> FamilySetsIntervals {
    return FamilySetsIntervals(familySetsIntervals: Set(self.familySetsIntervals.map({$0.filterLt(k)})))
  }
  
  /// Filter all sets of the family by a value k to keep only values that are greather than or equal to k.
  /// - Parameter k: The filter value
  /// - Returns: The new family with the filtered intervals
  func filterGeq(_ k: K) -> FamilySetsIntervals {
    return FamilySetsIntervals(familySetsIntervals: Set(self.familySetsIntervals.map({$0.filterGeq(k)})))
  }
  
  
  /// Compute the number of element in the family
  /// - Returns: The number of element in the family
  func count() -> Int {
    return self.familySetsIntervals.count
  }
  
}

extension FamilySetsIntervals where K: Countable {
  
  /// Canonized all sets of intervals in the family
  /// - Returns:The canonized family of sets of intervals
  func canonized() -> FamilySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: Set(self.familySetsIntervals.map({$0.canonized()})))
  }
}
