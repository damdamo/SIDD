import XCTest
@testable import SIDD

final class SetIntervalsTests: XCTestCase {
  
  func testInitialisation() {
    var i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 4, rbracket: .i))
    var i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 7, b: 10, rbracket: .i))
    var i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 6, rbracket: .i))
    var set: SetIntervals<Int> = SetIntervals(setIntervals: [i1,i2,i3])
    XCTAssertNil(set.setIntervals)
    
    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 4, rbracket: .i))
    i2 = Interval(intvl: .intvl(lbracket: .i, a: 7, b: 10, rbracket: .i))
    i3 = Interval(intvl: .intvl(lbracket: .e, a: 4, b: 6, rbracket: .i))
    set = SetIntervals(setIntervals: [i1,i2,i3])
    let expectedRes: Set<Interval<Int>> = [i1, i2, i3]
    
    XCTAssertEqual(set.setIntervals, expectedRes)
  }
  
  func testUnionBasic() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1, i2])
    let emptySetIntervals = SetIntervals<Int>(setIntervals: [])
    XCTAssertEqual(s1.union(emptySetIntervals), s1)
    XCTAssertEqual(emptySetIntervals.union(s1), s1)

    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 30, b: 40, rbracket: .i))
    let s2 = SetIntervals(setIntervals: [i3])
    var expectedRes = SetIntervals(setIntervals: [i1, i2, i3])
    XCTAssertEqual(s1.union(s2), expectedRes)
    
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 19, b: 25, rbracket: .i))
    let i5: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 25, rbracket: .i))
    let s3 = SetIntervals(setIntervals: [i4])
    expectedRes = SetIntervals(setIntervals: [i1, i5])
    XCTAssertEqual(s1.union(s3), expectedRes)    
  }
  
  func testIntersectionBasic() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    
    // {[1,5]} ∩ {(10,15]} = Ø
    // {(10,15]} ∩ {[1,5]} = Ø
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let emptySetIntervals = SetIntervals<Int>(setIntervals: [])
    XCTAssertEqual(s1.intersection(s2), emptySetIntervals)
    XCTAssertEqual(s2.intersection(s1), emptySetIntervals)

    // {[5,15]} ∩ {(10,15]} = {[10,15]}
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 5, b: 15, rbracket: .i))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 15, rbracket: .i))
    let s3 = SetIntervals(setIntervals: [i3])
    var expectedRes = SetIntervals(setIntervals: [i4])
    XCTAssertEqual(s2.intersection(s3), expectedRes)

    // {[1,5], [10,15]} ∩ {(4,13]} = {(4,5], [10,13]}
    let i5: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 4, b: 13, rbracket: .i))
    let i6: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 4, b: 5, rbracket: .i))
    let i7: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 13, rbracket: .i))
    let s4 = SetIntervals(setIntervals: [i1, i4])
    let s5 = SetIntervals(setIntervals: [i5])
    expectedRes = SetIntervals(setIntervals: [i6, i7])
    XCTAssertEqual(s4.intersection(s5), expectedRes)
  }
  
  func testUnionComplete() {
    // {[3,15], [16,35]} ∪ {[1,5], [10,20], [30,42]}   = {[1,42]}
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 30, b: 42, rbracket: .i))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 15, rbracket: .i))
    let i5: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 16, b: 35, rbracket: .i))
    let expectedRes = SetIntervals(setIntervals: [Interval(intvl: .intvl(lbracket: .i, a: 1, b: 42, rbracket: .i))])
    
    let s1 = SetIntervals(setIntervals: [i4, i5])
    let s2 = SetIntervals(setIntervals: [i1, i2, i3])
    XCTAssertEqual(s1.union(s2), expectedRes)
  }
  
  func testIntersectionComplete() {
    // {[3,15], (16,35]} ∩ {[1,5], [10,20], [30,42]}   = {[3,5], [10,15], (16,20] [30,35]}
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 30, b: 42, rbracket: .i))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 15, rbracket: .i))
    let i5: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 16, b: 35, rbracket: .i))
    
    let i6: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
    let i7: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 15, rbracket: .i))
    let i8: Interval<Int> = Interval(intvl: .intvl(lbracket: .e, a: 16, b: 20, rbracket: .i))
    let i9: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 30, b: 35, rbracket: .i))
    let expectedRes = SetIntervals(setIntervals: [i6, i7, i8, i9])
    
    let s1 = SetIntervals(setIntervals: [i4, i5])
    let s2 = SetIntervals(setIntervals: [i1, i2, i3])
    XCTAssertEqual(s1.intersection(s2), expectedRes)
  }
  
//  func testIntersection() {
//
//    // [1,2] ∩ [2,5] = [2,2]
//    var i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
//    var i2: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
//    var expectedRes: Interval<Int> = Interval(intvl:.intvl(lbracket: .i, a: 2, b: 2, rbracket: .i))
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//
//
//    // [1,1] ∩ [2,5] = Ø
//    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 1, rbracket: .i))
//    i2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
//    expectedRes = Interval(intvl: .empty)
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//
//
//    // [1,8] ∩ [3,5] = [3,5]
//    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i))
//    i2 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
//    expectedRes = i2
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//
//    // [3,5] ∩ [1,8] = [3,5]
//    i1 = Interval(intvl: .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i))
//    i2 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i))
//    expectedRes = i1
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//
//    // [1,2) ∩ [2,5] = Ø
//    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e))
//    i2 = Interval(intvl: .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i))
//    expectedRes = Interval(intvl: .empty)
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//
//    // [1,2] ∩ (2,5] = Ø
//    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i))
//    i2 = Interval(intvl: .intvl(lbracket: .e, a: 2, b: 5, rbracket: .i))
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//
//    // [1,2) ∩ (2,5] = Ø
//    i1 = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e))
//    i2 = Interval(intvl: .intvl(lbracket: .e, a: 2, b: 5, rbracket: .i))
//    XCTAssertEqual(i1.intersection(i2), expectedRes)
//  }
  
}
