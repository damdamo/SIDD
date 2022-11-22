/// A structure that contains a family of sets of intervals with additional constraints and operations to work on these sets of intervals.
public struct FamilySetsIntervals<K: Comparable & Hashable>: Hashable {
 
  let familySetsIntervals: Set<SetIntervals<K>>?
  
  /// Union of families of sets of intervals. This is similar to a set union.
  /// - Parameter f: The family to merge
  /// - Returns: The union of the two families
  func union(_ f: FamilySetsIntervals) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals, let f1 = f.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: familySetsIntervals.union(f1))
    }
    return nil
  }
  
  /// Intersection of families of sets of intervals. This is similar to a set intersection.
  /// - Parameter f: The family to intersect
  /// - Returns: The intersection of the two families
  func intersection(_ f: FamilySetsIntervals) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals, let f1 = f.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: familySetsIntervals.intersection(f1))
    }
    return nil
  }
  
  /// Difference of families of sets of intervals. This is similar to a set difference.
  /// - Parameter f: The family to subtract
  /// - Returns: The difference of the two sets
  func difference(_ f: FamilySetsIntervals) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals, let f1 = f.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: familySetsIntervals.subtracting(f1))
    }
    return nil
  }
  
  /// Inclusion of a family of sets of intervals inside another one. This is similar to a set inclusion.
  /// - Parameter f: The family to belong
  /// - Returns: True if all the sets from the left belong to the right family.
  func isIncludedIn(_ f: FamilySetsIntervals) -> Bool {
    if let familySetsIntervals = self.familySetsIntervals, let f1 = f.familySetsIntervals {
      return familySetsIntervals.isSubset(of: f1)
    }
    return false
  }
  
  /// Addition an interval in a family. This is the recursive operation of the addition on all sets.
  /// - Parameter i: The interval to add
  /// - Returns: The new family with the added interval in all sets
  func add(_ i: Interval<K>) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: Set(familySetsIntervals.map({$0.add(i)!})))
    }
    return nil
  }
  
  /// Subtraction of an interval in a family. This is the recursive operation of the subtraction on all sets.
  /// - Parameter i: The interval to subtract
  /// - Returns: The new family with the subtracted interval in all sets
  func sub(_ i: Interval<K>) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: Set(familySetsIntervals.map({$0.sub(i)!})))
    }
    return nil
  }
  
  /// Filter all sets of the family by a value k to keep only values that are lower than k.
  /// - Parameter k: The filter value
  /// - Returns: The new family with the filtered intervals
  func filterLt(_ k: K) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: Set(familySetsIntervals.map({$0.filterLt(k)!})))
    }
    return nil
  }
  
  /// Filter all sets of the family by a value k to keep only values that are greather than or equal to k.
  /// - Parameter k: The filter value
  /// - Returns: The new family with the filtered intervals
  func filterGeq(_ k: K) -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: Set(familySetsIntervals.map({$0.filterGeq(k)!})))
    }
    return nil
  }
  
}

extension FamilySetsIntervals where K: Countable {
  
  /// Canonized all sets of intervals in the family
  /// - Returns:The canonized family of sets of intervals
  func canonized() -> FamilySetsIntervals? {
    if let familySetsIntervals = self.familySetsIntervals {
      return FamilySetsIntervals(familySetsIntervals: Set(familySetsIntervals.map({$0.canonized()!})))
    }
    return nil
  }
}
