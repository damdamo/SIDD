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
    var i: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 1, rbracket: .i))
    let iEmpty: Interval<Int> = Interval(intvl: .empty)
    
    XCTAssertNil(i.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 3, rbracket: .e))
    XCTAssertEqual(i.intvl, iEmpty.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .e, a: 3, b: 3, rbracket: .i))
    XCTAssertEqual(i.intvl, iEmpty.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .e, a: 3, b: 3, rbracket: .e))
    XCTAssertEqual(i.intvl, iEmpty.intvl)
    
    i = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 3, rbracket: .i))
    XCTAssertEqual(i.intvl, Interval.Intvl.intvl(lbracket: .i, a: 3, b: 3, rbracket: .i))
    
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
  }
  
  func testUnion() {
    
    // [1,2] ∪ [2,5] = {[2,2]}
    var i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
    var i2: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    var expectedRes: SetIntervals<Int> = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))])
//    var expectedRes: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    XCTAssertEqual(i1.union(i2), expectedRes)
    
    // TODO The test does not pass for now, need the canonicity for countable sets !
    // [1,1] ∪ [2,5] = {[1,5]}
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 1, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
    expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))])
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

  
}
