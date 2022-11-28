import XCTest
@testable import SIDD

final class UseCaseTests: XCTestCase {
    
  func combinatoryProcesses(processIntervals: [Int: Set<Interval<Int>>]) -> FamilySetsIntervals<Int> {
        
    if processIntervals == [:] {
      return FamilySetsIntervals(familySetsIntervals: [SetIntervals(setIntervals: [])])
    }
    
    var f = FamilySetsIntervals<Int>(familySetsIntervals: [])
    var mutProcessIntervals = processIntervals
    
    if let (processNb, set) = processIntervals.first {
      mutProcessIntervals[processNb] = nil
      let tempFamily = combinatoryProcesses(processIntervals: mutProcessIntervals)
      for interval in set {
        f = f.union(tempFamily.add(interval)!)!
      }
    }
    
    return f
  }
  
  func sscProcess(processes: [Int: Int], totalTime: Int) -> FamilySetsIntervals<Int> {
    
    // Init all intervals for each process
    var processIntervals: [Int: Set<Interval<Int>>] = [:]
    for (processNb, time) in processes {
      var currentT = 0
      processIntervals[processNb] = []
      while totalTime - (currentT + time) >= 0 {
        processIntervals[processNb]!.insert(Interval(intvl: .intvl(lbracket: .i, a: currentT, b: currentT + time, rbracket: .e)))
        currentT += 1
      }
    }
    
    let nb = processes.keys.count
    
    var res = combinatoryProcesses(processIntervals: processIntervals)
    res = FamilySetsIntervals(familySetsIntervals: res.familySetsIntervals?.filter({$0.setIntervals?.count == nb}))
    
    return res
  }
  
  func testMultipleProcesses() {
        
    let x = sscProcess(processes: [1: 3, 2: 5, 3: 9, 4: 7], totalTime: 25)
    
    print(x.count())
    
  }
  
  }
