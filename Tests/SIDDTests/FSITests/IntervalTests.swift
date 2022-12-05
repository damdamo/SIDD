import XCTest
@testable import SIDD

extension Int: Countable {
  public typealias K = Int
  public func next() -> Int {
    return self + 1
  }
  public func pre() -> Int {
    return self - 1
  }
}

final class IntervalTests: XCTestCase {
  
  func testInitialisation() {
    let iEmpty: Interval<Int> = Interval(intvl: .empty)
    var i = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 3, rbracket: .e))
    XCTAssertEqual(i.intvl, iEmpty.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .e, a: 3, b: 3, rbracket: .i))
    XCTAssertEqual(i.intvl, iEmpty.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .e, a: 3, b: 3, rbracket: .e))
    XCTAssertEqual(i.intvl, iEmpty.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 3, rbracket: .i))
    XCTAssertEqual(i.intvl, Interval.Intvl.intvl(lbracket: .i, a: 3, b: 3, rbracket: .i))
  }
  
  func testCanonisation() {
    var i = Interval(intvl: .intvl(lbracket: .e, a: 1, b: 3, rbracket: .e))
    var expectedResult = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 2, rbracket: .i))
    XCTAssertEqual(i.canonized(), expectedResult)
    
    i = Interval(intvl: .intvl(lbracket: .e, a: 1, b: 3, rbracket: .i))
    expectedResult = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 3, rbracket: .i))
    XCTAssertEqual(i.canonized(), expectedResult)
  }
  
  func testIntersection() {
    
    // [1,2] ∩ [2,5] = [2,2]
    var i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
    var i2: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    var expectedRes: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 2, b: 2, rbracket: .i))
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    
    
    // [1,1] ∩ [2,5] = Ø
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 1, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    expectedRes = Interval(intvl: .empty)
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    
    // [1,10] ∩ Ø = Ø
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))
    i2 = Interval(intvl: .empty)
    expectedRes = Interval(intvl: .empty)
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    

    // [1,8] ∩ [3,5] = [3,5]
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
    expectedRes = i2
    XCTAssertEqual(i1.intersection(i2), expectedRes)

    // [3,5] ∩ [1,8] = [3,5]
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i))
    expectedRes = i1
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    
    // [1,2) ∩ [2,5] = Ø
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    expectedRes = Interval(intvl: .empty)
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    
    // [1,2] ∩ (2,5] = Ø
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 2, b: 5, rbracket: .i))
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    
    // [1,2) ∩ (2,5] = Ø
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 2, b: 5, rbracket: .i))
    XCTAssertEqual(i1.intersection(i2), expectedRes)
    
    // (10,20] ∩ [16,20] = []
    i1 = Interval(intvl: .intvl(lbracket: .e, a: 10, b: 20, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 16, b: 20, rbracket: .i))
    XCTAssertEqual(i1.intersection(i2), i2)
  }
  
  func testUnion() {
    
    // [1,2] ∪ [2,5] = {[2,2]}
    var i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
    var i2: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    var expectedRes: SetIntervals<Int> = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))])
//    var expectedRes: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    XCTAssertEqual(i1.union(i2), expectedRes)

    // [1,10] ∪ Ø = {[1,10]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))
    i2 = Interval(intvl: .empty)
    expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))])
    XCTAssertEqual(i1.union(i2), expectedRes)
    
    // Ø ∪ [1,10] = {[1,10]}
    i1 = Interval(intvl: .empty)
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))])
    XCTAssertEqual(i1.union(i2), expectedRes)


    // [1,8] ∪ [3,5] = {[1,8]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [i1])
    XCTAssertEqual(i1.union(i2), expectedRes)

    // [3,5] ∪ [1,8] = {[1,8]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [i2])
    XCTAssertEqual(i1.union(i2), expectedRes)

    // [1,2) ∪ [2,5] = {[1,2), [2,5]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [i1,i2])
    XCTAssertEqual(i1.union(i2), expectedRes)

    // [1,2] ∪ (2,5] = {[1,2], (2,5]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 2, b: 5, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [i1,i2])
    XCTAssertEqual(i1.union(i2), expectedRes)

    // [1,2) ∪ (2,5] = {[1,2), (2,5]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 2, b: 5, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [i1,i2])
    XCTAssertEqual(i1.union(i2), expectedRes)
  }
  
  func testDifference() {
    // Ø \ [2,5] = []
    // [2,5] \ Ø = {[2,5]}
    var i1: Interval<Int> = Interval(intvl: .empty)
    var i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    XCTAssertEqual(i1.difference(i2), SetIntervals(setIntervals: [i1]))
    XCTAssertEqual(i2.difference(i1), SetIntervals(setIntervals: [i2]))
    
    // [1,6] \ (6,8] = {[6,8]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 6, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 6, b: 8, rbracket: .i))
    var expectedRes = SetIntervals(setIntervals: [i1])
    XCTAssertEqual(i1.difference(i2), expectedRes)
    
    // [1,10] \ (6,12] = {[1,6]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 6, b: 12, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 6, rbracket: .i))])
    XCTAssertEqual(i1.difference(i2), expectedRes)
    
    // [1,20] \ (6,12] = {[1,6], (12,20]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 20, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 6, b: 12, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 6, rbracket: .i)), Interval(intvl: .intvl(lbracket: .e, a: 12, b: 20, rbracket: .i))])
    XCTAssertEqual(i1.difference(i2), expectedRes)
    
    // [10,20] \ (6,15] = {(15,20]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 6, b: 15, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .e, a: 15, b: 20, rbracket: .i))])
    XCTAssertEqual(i1.difference(i2), expectedRes)
    
    // [1,10] \ (0,11) = {[]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .e, a: 0, b: 11, rbracket: .e))
    expectedRes = SetIntervals(setIntervals: [])
    XCTAssertEqual(i1.difference(i2), expectedRes)
  }
  
  func testFilterLt() {
    let emptyInterval: Interval<Int> = Interval(intvl: .empty)
    // [6,12]
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 6, b: 12, rbracket: .i))
    // [6,9)
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 6, b: 9, rbracket: .e))
    
    // filterLt(Ø, 3) = Ø
    XCTAssertEqual(emptyInterval.filterLt(3), emptyInterval)
    // filterLt([6,12], 9) = [6,9)
    XCTAssertEqual(i1.filterLt(9), i2)
    // filterLt([6,12], 6) = Ø
    XCTAssertEqual(i1.filterLt(6), emptyInterval)
    // filterLt([6,12], 13) = [6,12]
    XCTAssertEqual(i1.filterLt(13), i1)
  }
  
  func testFilterGeq() {
    let emptyInterval: Interval<Int> = Interval(intvl: .empty)
    // [6,12]
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 6, b: 12, rbracket: .i))
    // [9,12]
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 9, b: 12, rbracket: .i))
    
    // filterGeq(Ø, 3) = Ø
    XCTAssertEqual(emptyInterval.filterGeq(3), emptyInterval)
    // filterGeq([6,12], 9) = [9,12]
    XCTAssertEqual(i1.filterGeq(9), i2)
    // filterLt([6,12], 6) = [6,12]
    XCTAssertEqual(i1.filterGeq(6), i1)
    // filterLt([6,12], 13) = Ø
    XCTAssertEqual(i1.filterGeq(13), emptyInterval)
  }
  
  func testIsIncludedIn() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 4, b: 10, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 10, rbracket: .e))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 10, rbracket: .i))
    let emptyInterval: Interval<Int> = Interval(intvl: .empty)
    
    // Ø ⊆ [4,10] = true
    XCTAssertTrue(emptyInterval.isIncludedIn(i: i1))
    // [4,10] ⊆ Ø = false
    XCTAssertFalse(i1.isIncludedIn(i: emptyInterval))
    // [4,10] ⊆ [2,5] = false
    XCTAssertFalse(i1.isIncludedIn(i: i2))
    // [4,10] ⊆ [2,10) = false
    XCTAssertFalse(i1.isIncludedIn(i: i3))
    // [4,10] ⊆ [2,10] = true
    XCTAssertTrue(i1.isIncludedIn(i: i4))
  }

  
}
