/// A SIDD factory.
///
/// For the sake of performance, all decision diagram nodes should be unique so that an operations
/// on them can be cached. This factory guarantees such a uniqueness by keeping track of all
/// created nodes in a uniqueness table. When the method `node(key:take:skip:)` is called, this
/// table is queried to make sure there is not any existing node with the same parameters.
///
/// The factory also implements low-level family operations, such as the union, intersection,
/// symmetric difference (a.k.a. disjoint union) and subtraction.
///
/// In an effort to alleviate the cost of memory allocation, the uniqueness table is implemented as
/// a memory arena which gets allocated in large chunks of memory, called _buckets_. A bucket is
/// merely an array of nodes which is used as a hash table, using open addressing with quadratic
/// probing to handle hash collisions. When the load factor of a bucket is too high, an additional
/// bucket of the same size is created. Since this does not trigger any resizing, the addresses of
/// the slots in use are not invalidated.
public final class SIDDFactory<Key>: DecisionDiagramFactory where Key: Comparable & Hashable {

  public typealias DD = SIDD<Key>

  /// A factory's cache for the results of family operations.
  struct Cache {

    var union: [[SIDD<Key>.Pointer]: SIDD<Key>.Pointer] = [:]

    var intersection: [[SIDD<Key>.Pointer]: SIDD<Key>.Pointer] = [:]

    var symmetricDifference: [[SIDD<Key>.Pointer]: SIDD<Key>.Pointer] = [:]

    var subtraction: [[SIDD<Key>.Pointer]: SIDD<Key>.Pointer] = [:]

  }

  /// A pointer to this factory's zero terminal.
  let zeroPointer: SIDD<Key>.Pointer

  /// A pointer to this factory's one terminal.
  let onePointer: SIDD<Key>.Pointer

  /// This factory's node buckets.
  private var buckets: [SIDD<Key>.Pointer]

  /// The capacity of a single node bucket.
  private let bucketCapacity: Int

  /// This factory's cache for the results of family operations.
  var cache = Cache()

  /// The zero terminal.
  public var zero: SIDD<Key> {
    SIDD(pointer: zeroPointer, factory: self)
  }

  /// The one terminal.
  public var one: SIDD<Key> {
    SIDD(pointer: onePointer, factory: self)
  }

  /// A Boolean value indicating whether the given pointer points to a terminal node.
  func isTerminal(_ pointer: SIDD<Key>.Pointer) -> Bool {
    pointer == zeroPointer || pointer == onePointer
  }

  public func isEmpty(_ pointer: SIDD<Key>.Pointer) -> Bool {
    return pointer == zeroPointer
  }

  /// The number of nodes created by the factory.
  public var createdCount: Int {
    var count = 0
    for bucket in buckets {
      for i in 0 ..< bucketCapacity where (bucket + i).pointee.inUse {
        count += 1
      }
    }
    return count
  }

  /// The associated morphism factory.
  public lazy var morphisms: SIDDMorphismFactory<Key> = { [unowned self] in
    SIDDMorphismFactory(nodeFactory: self)
  }()

  /// Creates a new SIDD factory.
  ///
  /// - Parameter bucketCapacity: The number of slots to allocate for each bucket.
  public init(bucketCapacity: Int = 1024) {
    precondition(bucketCapacity > 0)
    self.bucketCapacity = bucketCapacity

    // Allocate the terminals.
    zeroPointer = SIDD<Key>.Pointer.allocate(capacity: 2)
    onePointer = zeroPointer + 1
    for i in 0 ... 1 {
      let terminal = zeroPointer + i
      terminal.pointee.inUse = true
      terminal.pointee.precomputedHash = i
    }

    // Allocate the first bucket.
    buckets = [SIDD<Key>.Pointer.allocate(capacity: bucketCapacity)]
    for i in 0 ..< bucketCapacity {
      (buckets[0] + i).pointee.inUse = false
    }
  }

  deinit {
    zeroPointer.deallocate()
    for i in 0 ..< buckets.count {
      buckets[i].deallocate()
    }
  }

  public func encode<S>(family: S) -> SIDD<Key>
    where S: Sequence, S.Element: Sequence, S.Element.Element == Key
  {
    let pointer = family.map({ (member: S.Element) -> SIDD<Key>.Pointer in
      var ptr = onePointer
      for key in Set(member).sorted().reversed() {
        ptr = node(key: key, take: ptr, skip: zeroPointer, isIncluded: true)
      }
      return ptr
    })
    return SIDD(pointer: union(of: pointer), factory: self)
  }
  
  public func decode(sidd: SIDD<Key>) -> FamilySetsIntervals<Key> {
    if sidd.pointer == zeroPointer {
      return FamilySetsIntervals(familySetsIntervals: [])
    } else if sidd.pointer == onePointer {
      return FamilySetsIntervals(familySetsIntervals: [SetIntervals(setIntervals: [])])
    }
    
    return decode(sidd: sidd, bound: sidd.pointer.pointee.key, isIncluded: sidd.pointer.pointee.isIncluded)
  }
  
  private func decode(sidd: SIDD<Key>, bound: Key, isIncluded: Bool) -> FamilySetsIntervals<Key> {
    if sidd.pointer == zeroPointer {
      return FamilySetsIntervals(familySetsIntervals: [])
    } else if sidd.pointer == onePointer {
      return FamilySetsIntervals(familySetsIntervals: [SetIntervals(setIntervals: [])])
    }
    
    let take = sidd.pointer.pointee.take
    let skip = sidd.pointer.pointee.skip
    
    if take == zeroPointer && isTerminal(skip) {
      return decode(sidd: SIDD(pointer: skip, factory: self), bound: bound, isIncluded: isIncluded)
    } else if take == zeroPointer && !isTerminal(skip) {
      return decode(sidd: SIDD(pointer: skip, factory: self), bound: skip.pointee.key, isIncluded: skip.pointee.isIncluded)
    } else if !isTerminal(take) && isTerminal(skip) {
      return decodeTau(sidd: SIDD(pointer: take, factory: self), bound: bound, isIncluded: isIncluded).union(decode(sidd: SIDD(pointer: skip, factory: self), bound: bound, isIncluded: isIncluded))
    }
    
    return decodeTau(sidd: SIDD(pointer: take, factory: self), bound: bound, isIncluded: isIncluded).union(decode(sidd: SIDD(pointer: skip, factory: self), bound: skip.pointee.key, isIncluded: skip.pointee.isIncluded))
      
  }
  
  private func decodeTau(sidd: SIDD<Key>, bound: Key, isIncluded: Bool) -> FamilySetsIntervals<Key> {
    if sidd.pointer == zeroPointer {
      return FamilySetsIntervals(familySetsIntervals: [])
    }
    
    let take = sidd.pointer.pointee.take
    let skip = sidd.pointer.pointee.skip
    
    if take == zeroPointer {
      if skip == zeroPointer {
        return FamilySetsIntervals(familySetsIntervals: [])
      } else if skip == onePointer {
        let lbracket: Interval<Key>.Lbracket = isIncluded ? .i : .e
        let rbracket: Interval<Key>.Rbracket = sidd.pointer.pointee.isIncluded ? .i : .e
        return FamilySetsIntervals(
          familySetsIntervals: [
            SetIntervals(
              setIntervals: [Interval(intvl: .intvl(lbracket: lbracket, a: bound, b: sidd.pointer.pointee.key, rbracket: rbracket))]
            )
          ]
        )
      }
      return decode(sidd: SIDD(pointer: skip, factory: self), bound: skip.pointee.key, isIncluded: skip.pointee.isIncluded)
    }
    
    if isTerminal(skip) {
      return decodeTau(sidd: SIDD(pointer: take, factory: self), bound: take.pointee.key, isIncluded: isIncluded).union(decode(sidd: SIDD(pointer: skip, factory: self), bound: bound, isIncluded: isIncluded))
    }
    
    let lbracket: Interval<Key>.Lbracket = isIncluded ? .i : .e
    let rbracket: Interval<Key>.Rbracket = sidd.pointer.pointee.isIncluded ? .i : .e
    let interval = Interval<Key>(intvl: .intvl(lbracket: lbracket, a: bound, b: sidd.pointer.pointee.key, rbracket: rbracket))
    
    return decodeTau(sidd: SIDD(pointer: take, factory: self), bound: take.pointee.key, isIncluded: isIncluded).union(decode(sidd: SIDD(pointer: skip, factory: self), bound: skip.pointee.key, isIncluded: isIncluded).add(interval))
    
  }

  /// Creates a new SIDD node.
  ///
  /// - Parameters:
  ///   - key: The node's key.
  ///   - take: The SIDD representing the suffix if the key is kept.
  ///   - skip: The SIDD representing the suffix if the key is dropped.
  ///
  /// - Returns: A SIDD node corresponding to the given parameters.
  public func node(key: Key, take: SIDD<Key>.Pointer, skip: SIDD<Key>.Pointer, isIncluded: Bool) -> SIDD<Key>.Pointer {
//    guard take != zeroPointer
//      else { return skip }
    precondition(
      take != self.onePointer,
      "Invalid declaration of an SIDD: tau value cannot contain top value")
    precondition(
      isTerminal(take) || key < take.pointee.key,
      "Invalid variable ordering: the take branch should have a greater key.")
    precondition(
      isTerminal(skip) || key < skip.pointee.key,
      "Invalid variable ordering: the skip branch should have a greater key.")

    // Search if there already exists a node with the given parameters.
    var hasher = Hasher()
    hasher.combine(key)
    hasher.combine(take)
    hasher.combine(skip)
    let hash = hasher.finalize()

    let remainder = hash % bucketCapacity
    let index = remainder >= 0 ? remainder : remainder + bucketCapacity
    for bucket in buckets {
      for i in 0 ..< 8 {
        // Compute the slot offset with quadratic function.
        let offset = index + Int((0.5 * Double(i)) + (0.5 * Double(i) * Double(i)))
        let pointer = offset < bucketCapacity
          ? bucket + offset
          : bucket + (offset % bucketCapacity)

        guard pointer.pointee.inUse else {
          // The current slot is not in use. This means that there isn't any node satisfying the
          // given parameters, and that we may use the slot to store a new one.
          pointer.initialize(to: SIDD.Node(
            inUse: true,
            key: key,
            take: take,
            skip: skip,
            isIncluded: isIncluded,
            precomputedHash: hash))
          return pointer
        }

        let node = pointer.pointee
        if node.precomputedHash == hash
          && node.key == key
          && node.take == take
          && node.skip == skip
        {
          // The current slot satisfies to the given parameters, so we return a pointer thereto.
          return pointer
        }
      }
    }

    // Since we got too many cache misses in all allocated buckets, we'll allocate a new one.
    buckets.append(SIDD<Key>.Pointer.allocate(capacity: bucketCapacity))
    let base = buckets[buckets.count - 1]
    for i in 0 ..< bucketCapacity {
      (base + i).pointee.inUse = false
    }

    // Use a slot in the freshly allocated bucket.
    let pointer = base + index
    pointer.initialize(to: SIDD.Node(
      inUse: true,
      key: key,
      take: take,
      skip: skip,
      isIncluded: isIncluded,
      precomputedHash: hash))
    return pointer
  }

}
