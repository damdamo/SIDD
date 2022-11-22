import XCTest
@testable import SIDD

final class FamilySetsIntervalsTests: XCTestCase {
  
  func testUnion() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s2])
    let f3 = FamilySetsIntervals(familySetsIntervals: [s1, s2])
    
    // {{[1,5]}} ∪ {{[10,20]}} = {{[1,5]}, {[10,20]}}
    XCTAssertEqual(f1.union(f2), f3)
  }
  
  func testIntersection() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s1, s2])
    let f3 = FamilySetsIntervals(familySetsIntervals: [s1])
    
    // {{[1,5]}} ∩ {{[1,5]}, {[10,20]}} = {{[1,5]}}
    XCTAssertEqual(f1.intersection(f2), f3)
  }
  
  func testDifference() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1,s2])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s1])
    let f3 = FamilySetsIntervals(familySetsIntervals: [s2])
    
    // {{[1,5]}, {[10,20]}} \ {{[1,5]}} = {{[10,20]}}
    XCTAssertEqual(f1.difference(f2), f3)
  }
  
  
  func testAdd() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 25, rbracket: .i))
    let addInterval: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 15, b: 25, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let s3 = SetIntervals(setIntervals: [i1, addInterval])
    let s4 = SetIntervals(setIntervals: [i3])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1,s2])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s3,s4])
    
    // {{[1,5]}, {[10,20]}} + [15,25] = {{[1,5], [15,25]}, {[10,25]}}
    XCTAssertEqual(f1.add(addInterval), f2)
  }
  
  func testSub() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 15, rbracket: .e))
    let subInterval: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 15, b: 25, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let s3 = SetIntervals(setIntervals: [i3])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1,s2])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s1,s3])
    
    // {{[1,5]}, {[10,20]}} - [15,25] = {{[1,5]}, {[10,15)}}
    XCTAssertEqual(f1.sub(subInterval), f2)
  }
  
  func testFilterLt() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 15, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let k: Int = 12
    
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 12, rbracket: .e))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 12, rbracket: .e))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let s3 = SetIntervals(setIntervals: [i3])
    let s4 = SetIntervals(setIntervals: [i4])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1,s2])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s3,s4])
    
    // filterLt({{[1,15]}, {[10,20]}}, 12) = {{[1,12)}, {[10,12)}})
    XCTAssertEqual(f1.filterLt(k), f2)
  }
  
  func testFilterGeq() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 15, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let k: Int = 12
    
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 12, b: 15, rbracket: .i))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 12, b: 20, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let s3 = SetIntervals(setIntervals: [i3])
    let s4 = SetIntervals(setIntervals: [i4])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1,s2])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s3,s4])
    
    // filterGeq({{[1,15]}, {[10,20]}}, 12) = {{[12,15]}, {[12,20]}})
    XCTAssertEqual(f1.filterGeq(k), f2)
  }
  
  func testIsIncludedIn() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1])
    let s2 = SetIntervals(setIntervals: [i2])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s1, s2])
    
    // ({{[1,5]}} ⊆ {{[1,5]}, {[10,20]}}) = true
    XCTAssertTrue(f1.isIncludedIn(f2))
  }
  
  func testCanonized() {
    let i1: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 5, rbracket: .i))
    let i2: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 6, b: 10, rbracket: .i))
    let i3: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 20, rbracket: .i))
    let i4: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 21, b: 25, rbracket: .i))
    
    let i5: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 1, b: 10, rbracket: .i))
    let i6: Interval<Int> = Interval(intvl: .intvl(lbracket: .i, a: 10, b: 25, rbracket: .i))
    
    let s1 = SetIntervals(setIntervals: [i1,i2])
    let s2 = SetIntervals(setIntervals: [i3,i4])
    let s3 = SetIntervals(setIntervals: [i5])
    let s4 = SetIntervals(setIntervals: [i6])
    let f1 = FamilySetsIntervals(familySetsIntervals: [s1,s2])
    let f2 = FamilySetsIntervals(familySetsIntervals: [s3,s4])
    
    // canonied({{[1,5], [6,10]}, {[10,20],[10,25]}}) = {{[1,10]}, {[10,25]}}
    XCTAssertEqual(f1.canonized(), f2)
  }
}
