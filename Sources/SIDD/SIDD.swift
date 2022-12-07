public struct SIDD<Key>: DecisionDiagram where Key: Comparable & Hashable {

  public typealias Pointer = UnsafeMutablePointer<Node>
  public typealias Factory = SIDDFactory<Key>

  /// A node in the graph representation of a SIDD.
  public struct Node: Hashable {

    var inUse: Bool

    /// The key associated with this node.
    public var key: Key

    /// A pointer to this node's take branch.
    public var take: Pointer

    /// A pointer to this node's skip branch.
    public var skip: Pointer
    
    /// A boolean value to decide whether the bound is included or not
    public var isIncluded: Bool

    var precomputedHash: Int

    public func hash(into hasher: inout Hasher) {
      hasher.combine(precomputedHash)
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
      lhs.key == rhs.key && lhs.take == rhs.take && lhs.skip == rhs.skip
    }

  }

  /// The pointer to the actual underlying node.
  ///
  /// This property should be used for low-level operations and morphisms only.
  ///
  /// - Warning: The node pointed by this property corresponds to the actual representation of the
  ///   decision diagram, whose memory is controlled by the factory. For the sake of regularity,
  ///   terminal nodes (i.e. `zero` and `one`) are also represented as regular nodes, removing the
  ///   need for dynamic dispatch. However, dereferencing the key, take or skip property of a
  ///   terminal node will likely result in an unrecoverable memory error. Therefore, one should
  ///   always check that a pointer does not point to a terminal before dereferencing its pointee.
  public let pointer: Pointer

  /// The factory that created this family.
  public unowned let factory: SIDDFactory<Key>

  /// Initializes a SIDD from a node pointer and the factory that created it.
  public init(pointer: Pointer, factory: SIDDFactory<Key>) {
    self.pointer = pointer
    self.factory = factory
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(pointer)
  }

  public static func == (lhs: SIDD, rhs: SIDD) -> Bool {
    return lhs.pointer == rhs.pointer
  }

}
