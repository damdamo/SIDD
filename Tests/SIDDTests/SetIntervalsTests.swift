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
