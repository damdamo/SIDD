import XCTest
@testable import SIDD

final class IntervalTests: XCTestCase {
  func testIntersection() {
    
    // [1,2] ∩ [2,5] = [2,2]
    var i1: Interval<Int> = .intvl(lbracket: .i, a: 1, b: 2, rbracket: .i)
    var i2: Interval<Int> = .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i)
    var expectedRes: Interval<Int> = .intvl(lbracket: .i, a: 2, b: 2, rbracket: .i)
    XCTAssertEqual(Interval.intersection(i1: i1, i2: i2), expectedRes)
    
    // [1,1] ∩ [2,5] = Ø
    i1 = .intvl(lbracket: .i, a: 1, b: 1, rbracket: .i)
    i2 = .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i)
    expectedRes = .empty
    XCTAssertEqual(Interval.intersection(i1: i1, i2: i2), expectedRes)
    
    // [1,8] ∩ [3,5] = [3,5]
    i1 = .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i)
    i2 = .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i)
    expectedRes = i2
    XCTAssertEqual(Interval.intersection(i1: i1, i2: i2), expectedRes)
    
    // [3,5] ∩ [1,8] = [3,5]
    i1 = .intvl(lbracket: .i, a: 3, b: 5, rbracket: .i)
    i2 = .intvl(lbracket: .i, a: 1, b: 8, rbracket: .i)
    expectedRes = i1
    XCTAssertEqual(Interval.intersection(i1: i1, i2: i2), expectedRes)
    
//    // [1,2) ∩ [2,5] = Ø
//    i1 = .intvl(lbracket: .i, a: 1, b: 2, rbracket: .e)
//    i2 = .intvl(lbracket: .i, a: 2, b: 5, rbracket: .i)
//    expectedRes = .empty
//    XCTAssertEqual(Interval.intersection(i1: i1, i2: i2), expectedRes)
  }
}
