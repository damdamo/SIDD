/// A countable type for a strict total order relation <, is a type where we know how to compute the next element.
/// To simplify, we give also the function for pre.
protocol Countable {
  associatedtype K: Hashable & Comparable
  func next() -> K
  func pre() -> K
}
