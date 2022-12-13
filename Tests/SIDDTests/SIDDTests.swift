import XCTest
@testable import SIDD

final class SIDDTests: XCTestCase {
  
  func testEncode() {
    let factory = SIDDFactory<Int>()
    let interval1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let interval2: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 6, b: 7, rbracket: .i))
    let interval3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 8, b: 10, rbracket: .e))
    let interval4: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 15, b: 20, rbracket: .i))
//    let interval5: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 22, b: 22, rbracket: .i))
    
    let set1 = SetIntervals(setIntervals: [interval1, interval2, interval3, interval4])
    let set2 = SetIntervals(setIntervals: [interval1, interval2, interval3])
    let set3 = SetIntervals(setIntervals: [interval1, interval2])
    let set4 = SetIntervals<Int>(setIntervals: [])
    
    let family = FamilySetsIntervals(familySetsIntervals: [set1, set2, set3, set4])
    
    let decEnc = factory.decode(sidd: factory.encode(family: family))
    
    // enc({}) = ⊥
    XCTAssertEqual(factory.encode(family: FamilySetsIntervals(familySetsIntervals: [])), factory.zero)
    // Family: {{[1,5], (6,7]}, {(15,20], [1,5], [8,10), (6,7]}, {[8,10), [1,5], (6,7]}, {}}
    XCTAssertEqual(decEnc, family)
//    print(decEnc)
  }
  
  func testDecode() {
    let factory = SIDDFactory<Int>()
    var node1 = factory.node(key: 5, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: false)
    var node2 = factory.node(key: 10, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    var node3 = factory.node(key: 8, take: node2, skip: factory.zeroPointer, isIncluded: false)
    var node4 = factory.node(key: 1, take: node1, skip: node3, isIncluded: true)
    
    var interval1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .e))
    var interval2: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 8, b: 10, rbracket: .i))
    var set1: SetIntervals<Int> = SetIntervals(setIntervals: [interval1])
    var set2: SetIntervals<Int> = SetIntervals(setIntervals: [interval2])
    var family: FamilySetsIntervals<Int> = FamilySetsIntervals(familySetsIntervals: [set1, set2])
    // Family: {{[1,5)}, {(8,10]}}
    XCTAssertEqual(factory.decode(sidd: SIDD(pointer: node4, factory: factory)), family)
    // print(factory.decode(sidd: SIDD(pointer: node4, factory: factory)))
    
    node1 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node2 = factory.node(key: 7, take: node1, skip: factory.onePointer, isIncluded: true)
    node3 = factory.node(key: 5, take: factory.zeroPointer, skip: node2, isIncluded: true)
    node4 = factory.node(key: 3, take: node3, skip: factory.zeroPointer, isIncluded: true)
    
    interval1 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
    interval2 = Interval(intvl: .intvl(lbracket: .i, a: 7, b: 9, rbracket: .i))
    set1 = SetIntervals(setIntervals: [interval1])
    set2 = SetIntervals(setIntervals: [interval1, interval2])
    family = FamilySetsIntervals(familySetsIntervals: [set1, set2])
    // Family: {{[3,5]}, {[3,5], [7,9]}}
    XCTAssertEqual(factory.decode(sidd: SIDD(pointer: node4, factory: factory)), family)
    
    node1 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node2 = factory.node(key: 7, take: node1, skip: factory.zeroPointer, isIncluded: true)
    node3 = factory.node(key: 3, take: node1, skip: node2, isIncluded: true)
    node4 = factory.node(key: 1, take: node3, skip: factory.zeroPointer, isIncluded: true)
    
    // Family: {{[1,9]}, {[1,3], [7,9]}}
    interval1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 9, rbracket: .i))
    interval2 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 3, rbracket: .i))
    let interval3 = Interval(intvl: .intvl(lbracket: .i, a: 7, b: 9, rbracket: .i))
    set1 = SetIntervals(setIntervals: [interval1])
    set2 = SetIntervals(setIntervals: [interval2, interval3])
    family = FamilySetsIntervals(familySetsIntervals: [set1, set2])
    XCTAssertEqual(factory.decode(sidd: SIDD(pointer: node4, factory: factory)), family)
    
    // Family: {{[2,9]}, {[2,6)}}
    node1 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node2 = factory.node(key: 6, take: node1, skip: factory.onePointer, isIncluded: false)
    node3 = factory.node(key: 2, take: node2, skip: factory.zeroPointer, isIncluded: true)
    interval1 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 9, rbracket: .i))
    interval2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 6, rbracket: .e))
    set1 = SetIntervals(setIntervals: [interval1])
    set2 = SetIntervals(setIntervals: [interval2])
    family = FamilySetsIntervals(familySetsIntervals: [set1, set2])
    XCTAssertEqual(factory.decode(sidd: SIDD(pointer: node3, factory: factory)), family)
  }
  
  func testUnion() {
    let factory = SIDDFactory<Int>()
    var node1 = factory.node(key: 5, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: false)
    var node2 = factory.node(key: 10, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    var node3 = factory.node(key: 8, take: node2, skip: factory.zeroPointer, isIncluded: false)
    var node4 = factory.node(key: 1, take: node1, skip: node3, isIncluded: true)

    var node5 = factory.node(key: 1, take: node1, skip: factory.zeroPointer, isIncluded: true)

    // Union: {{(8,10]}} U {{[1,5)}} = {{[1,5)}, {(8,10]}}
    XCTAssertEqual(factory.union(node3, node5), node4)
    
    node1 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node2 = factory.node(key: 7, take: node1, skip: factory.onePointer, isIncluded: true)
    node3 = factory.node(key: 5, take: factory.zeroPointer, skip: node2, isIncluded: true)
    node4 = factory.node(key: 3, take: node3, skip: factory.zeroPointer, isIncluded: true)
    
    node5 = factory.node(key: 6, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    let node6 = factory.node(key: 3, take: node5, skip: factory.zeroPointer, isIncluded: true)
    
    let node7 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    let node8 = factory.node(key: 7, take: node7, skip: factory.onePointer, isIncluded: true)
    let node9 = factory.node(key: 6, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    let node10 = factory.node(key: 5, take: node9, skip: node8, isIncluded: true)
    let node11 = factory.node(key: 3, take: node10, skip: factory.zeroPointer, isIncluded: true)

    // Union: {{[3,5]}, {[3,5], [7,9]}} U {{[3,6]}} = {{[3,5]}, {[3,5], [7,9]}, {[3,6]}}
    XCTAssertEqual(node11, factory.union(node4, node6))
  }
  
  func testInsertion() {
    var morphisms: SIDDMorphismFactory<Int> {factory.morphisms}
    let factory = SIDDFactory<Int>()
    var node1 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    var node2 = factory.node(key: 6, take: node1, skip: factory.onePointer, isIncluded: true)
    var node3 = factory.node(key: 2, take: node2, skip: factory.zeroPointer, isIncluded: true)
    var interval: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 10, rbracket: .i))
    var morphism = morphisms.insert(interval: interval)
        
    var node4 = factory.node(key: 10, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    var node5 = factory.node(key: 2, take: node4, skip: factory.zeroPointer, isIncluded: true)
    
    // T + [2,10] = {{[2,10]}}
    XCTAssertEqual(morphism.apply(on: factory.onePointer), node5)
    // {{[2,6]}, {[2,9]}} + [2,10] = {{[2,10]}}
    XCTAssertEqual(morphism.apply(on: node3), node5)
    var node6 = factory.node(key: 1, take: factory.zeroPointer, skip: node3, isIncluded: true)
    // {{[2,6]}, {[2,9]}} + [2,10] = {{[2,10]}} (However the SIDD starts with 1 that is skipped
    XCTAssertEqual(morphism.apply(on: node6), node5)
    // <1, ⊥, ⊥> + [2,10] = ⊥
    node6 = factory.node(key: 1, take: factory.zeroPointer, skip: factory.zeroPointer, isIncluded: true)
    XCTAssertEqual(morphism.apply(on: node6), factory.zeroPointer)
    node6 = factory.node(key: 1, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    // <1, ⊥, T> + [2,10] = {{[2,10]}}
    XCTAssertEqual(morphism.apply(on: node6), node5)
    
    interval = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 7, rbracket: .i))
    node4 = factory.node(key: 9, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node5 = factory.node(key: 7, take: node4, skip: factory.onePointer, isIncluded: true)
    node6 = factory.node(key: 1, take: node5, skip: factory.zeroPointer, isIncluded: true)
    morphism = morphisms.insert(interval: interval)
    
    // {{[2,6]}, {[2,9]}} + [1,7] = {{[1,7]}, {[1,9]}}
    XCTAssertEqual(morphism.apply(on: node3), node6)
    
    node1 = factory.node(key: 25, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node2 = factory.node(key: 20, take: node1, skip: factory.zeroPointer, isIncluded: true)
    node3 = factory.node(key: 6, take: factory.zeroPointer, skip: node2, isIncluded: true)
    node4 = factory.node(key: 2, take: node3, skip: factory.zeroPointer, isIncluded: true)
    
    interval = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 15, rbracket: .i))
    morphism = morphisms.insert(interval: interval)
    
    node5 = factory.node(key: 25, take: factory.zeroPointer, skip: factory.onePointer, isIncluded: true)
    node6 = factory.node(key: 20, take: node5, skip: factory.zeroPointer, isIncluded: true)
    var node7 = factory.node(key: 15, take: factory.zeroPointer, skip: node6, isIncluded: true)
    let node8 = factory.node(key: 10, take: node7, skip: factory.zeroPointer, isIncluded: true)
    var node9 = factory.node(key: 6, take: factory.zeroPointer, skip: node8, isIncluded: true)
    var node10 = factory.node(key: 2, take: node9, skip: factory.zeroPointer, isIncluded: true)
    
    // {{[20,25], [2,6]}} + [10,15] = {{[2,6], [10,15], [20,25]}}
    XCTAssertEqual(morphism.apply(on: node4), node10)

    interval = Interval(intvl: .intvl(lbracket: .i, a: 5, b: 15, rbracket: .i))
    morphism = morphisms.insert(interval: interval)
    
    node9 = factory.node(key: 2, take: node7, skip: factory.zeroPointer, isIncluded: true)
    // {{[20,25], [2,6]}} + [5,15] = {{[20,25], [2,15]}}
    XCTAssertEqual(morphism.apply(on: node4), node9)

    interval = Interval(intvl: .intvl(lbracket: .i, a: 5, b: 21, rbracket: .i))
    morphism = morphisms.insert(interval: interval)
    
    node9 = factory.node(key: 2, take: node5, skip: factory.zeroPointer, isIncluded: true)
    // {{[2,6], [10,15], [20,25]}} + [5,21] = {{[2,25]}}
    XCTAssertEqual(morphism.apply(on: node10), node9)
    
    
    interval = Interval(intvl: .intvl(lbracket: .i, a: 15, b: 21, rbracket: .i))
    morphism = morphisms.insert(interval: interval)
    node7 = factory.node(key: 15, take: node1, skip: factory.zeroPointer, isIncluded: true)
    node9 = factory.node(key: 6, take: factory.zeroPointer, skip: node7, isIncluded: true)
    node10 = factory.node(key: 2, take: node9, skip: factory.zeroPointer, isIncluded: true)
        
    // {{[20,25], [2,6]}} + [15,21] = {{[15,25], [2,6]}}
    XCTAssertEqual(morphism.apply(on: node4), node10)
    
    interval = Interval(intvl: .intvl(lbracket: .i, a: 21, b: 25, rbracket: .i))
    morphism = morphisms.insert(interval: interval)
    // {{[20,25], [2,6]}} + [21,25] = {{[20,25], [2,6]}}
    XCTAssertEqual(morphism.apply(on: node4), node4)
    
  }
  
//  func testNodeCreation() {
//    let factory = SFDDFactory<Int>(bucketCapacity: 4)
//
//    _ = factory.encode(family: [0 ..< 10])
//    XCTAssertEqual(factory.createdCount, 10)
//  }
//
//  func testCount() {
//    let factory = SFDDFactory<Int>()
//
//    XCTAssertEqual(0, factory.zero.count)
//    XCTAssertEqual(1, factory.one.count)
//    XCTAssertEqual(1, factory.encode(family: [[1, 2]]).count)
//    XCTAssertEqual(2, factory.encode(family: [[1, 2], [1, 3]]).count)
//    XCTAssertEqual(2, factory.encode(family: [[1, 2], []]).count)
//  }
//
//  func testEquates() {
//    let factory = SFDDFactory<Int>()
//
//    XCTAssertEqual(factory.zero, factory.zero)
//    XCTAssertEqual(factory.one, factory.one)
//    XCTAssertEqual(factory.encode(family: [[]]), factory.one)
//    XCTAssertEqual(factory.encode(family: [[1, 2]]), factory.encode(family: [[1, 2]]))
//  }
//
//  func testContains() {
//    let factory = SFDDFactory<Int>()
//    var family: SFDD<Int>
//
//    family = factory.zero
//    XCTAssertFalse(family.contains([]))
//
//    family = factory.one
//    XCTAssert(family.contains([]))
//    XCTAssertFalse(family.contains([1]))
//
//    family = factory.encode(family: [[1]])
//    XCTAssertFalse(family.contains([]))
//    XCTAssert(family.contains([1]))
//    XCTAssertFalse(family.contains([2]))
//
//    family = factory.encode(family: [[1, 2], [1, 3], [1, 4]])
//    XCTAssert(family.contains([1, 2]))
//    XCTAssert(family.contains([1, 3]))
//    XCTAssert(family.contains([1, 4]))
//    XCTAssertFalse(family.contains([]))
//    XCTAssertFalse(family.contains([1]))
//    XCTAssertFalse(family.contains([1, 5]))
//  }
//
//  func testRandomElement() {
//    let factory = SFDDFactory<Int>()
//
//    XCTAssertNil(factory.zero.randomElement())
//    XCTAssertEqual(factory.one.randomElement(), factory.one.randomElement())
//
//    let family = factory.encode(family: [[1, 2, 3, 4], [1, 3, 4], [2, 3, 4]])
//    let member = family.randomElement()
//    XCTAssertNotNil(member)
//    if member != nil {
//      XCTAssert(Set([[1, 2, 3, 4], [1, 3, 4], [2, 3, 4]]).contains(member!))
//    }
//  }
//
//  func testBinaryUnion() {
//    let factory = SFDDFactory<Int>()
//    var a, b: SFDD<Int>
//
//    // Union of two identical families.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    XCTAssertEqual(a.union(a), a)
//
//    // Union of two different families.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    b = factory.encode(family: [[3, 5], [1, 3, 5], [4, 7]])
//    XCTAssertEqual(Set(a.union(b)), Set([[], [3, 5], [1, 3, 5], [4, 7]].map(Set.init)))
//
//    // Union with a sequence of members.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    let c = [[3, 5], [1, 3, 5], [4, 7]]
//    XCTAssertEqual(Set(a.union(c)), Set([[], [3, 5], [1, 3, 5], [4, 7]].map(Set.init)))
//  }
//
//  func testNaryUnion() {
//    let factory = SFDDFactory<Int>()
//    let dd = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//
//    // Union with an empty sequence of families.
//    XCTAssertEqual(dd.union(others: []), dd)
//
//    // Union with a single family.
//    let au1 = dd.union(others: [factory.encode(family: [[3, 5], [1, 3, 5], [4, 7]])])
//    XCTAssertEqual(Set(au1), Set([[], [3, 5], [1, 3, 5], [4, 7]].map(Set.init)))
//
//    // Union with two families.
//    let au2 = dd.union(others: [
//      factory.encode(family: [[1, 3, 5], [4, 7]]),
//      factory.encode(family: [[3, 5], [1, 3, 5]])
//    ])
//    XCTAssertEqual(Set(au2), Set([[], [3, 5], [1, 3, 5], [4, 7]].map(Set.init)))
//  }
//
//  func testBinaryIntersection() {
//    let factory = SFDDFactory<Int>()
//    var a, b: SFDD<Int>
//
//    // Intersection of two identical families.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    XCTAssertEqual(a.intersection(a), a)
//
//    // Intersection of two different families.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    b = factory.encode(family: [[3, 5], [1, 3, 5], [4, 7]])
//    XCTAssertEqual(Set(a.intersection(b)), Set([[3, 5], [1, 3, 5]].map(Set.init)))
//
//    // Intersection with a sequence of members.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    let c = [[3, 5], [1, 3, 5], [4, 7]]
//    XCTAssertEqual(Set(a.intersection(c)), Set([[3, 5], [1, 3, 5]].map(Set.init)))
//  }
//
//  func testNaryIntersection() {
//    let factory = SFDDFactory<Int>()
//    let dd = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//
//    // Union with an empty sequence of families.
//    XCTAssertEqual(dd.intersection(others: []), dd)
//
//    // Union with a single family.
//    let au1 = dd.intersection(others: [factory.encode(family: [[3, 5], [1, 3, 5], [4, 7]])])
//    XCTAssertEqual(Set(au1), Set([[3, 5], [1, 3, 5]].map(Set.init)))
//
//    // Union with two families.
//    let au2 = dd.intersection(others: [
//      factory.encode(family: [[1, 3, 5], [4, 7]]),
//      factory.encode(family: [[3, 5], [1, 3, 5]])
//    ])
//    XCTAssertEqual(Set(au2), Set([[1, 3, 5]].map(Set.init)))
//
//    let au3 = dd.intersection(others: [factory.one, factory.encode(family: [[3, 5], [1, 3, 5]])])
//    XCTAssertEqual(Set(au3), Set())
//  }
//
//  func testBinarySymmetricDifference() {
//    let factory = SFDDFactory<Int>()
//    var a, b: SFDD<Int>
//
//    // Symmetric difference between two identical families.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    XCTAssertEqual(a.symmetricDifference(a), factory.zero)
//
//    // Symmetric difference between two different families.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    b = factory.encode(family: [[3, 5], [1, 3, 5], [4, 7]])
//    XCTAssertEqual(Set(a.symmetricDifference(b)), Set([[], [4, 7]].map(Set.init)))
//
//    // Symmetric difference with a sequence of members.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    let c = [[3, 5], [1, 3, 5], [4, 7]]
//    XCTAssertEqual(Set(a.symmetricDifference(c)), Set([[], [4, 7]].map(Set.init)))
//  }
//
//  func testSubtraction() {
//    let factory = SFDDFactory<Int>()
//    var a, b: SFDD<Int>
//
//    // Subtraction of a family by itself.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    XCTAssertEqual(a.subtracting(a), factory.zero)
//
//    // Subtraction of a family by a different one.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    b = factory.encode(family: [[3, 5], [1, 3, 5], [4, 7]])
//    XCTAssertEqual(Set(a.subtracting(b)), Set([[]].map(Set.init)))
//
//    // Subtraction of a family by a sequence of members.
//    a = factory.encode(family: [[], [3, 5], [1, 3, 5]])
//    let c = [[3, 5], [1, 3, 5], [4, 7]]
//    XCTAssertEqual(Set(a.subtracting(c)), Set([[]].map(Set.init)))
//  }

}
