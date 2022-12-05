extension SetIntervals: CustomStringConvertible {
  public var description: String {
    if self.setIntervals == [] {
      return "[]"
    }
    var res: String = "{"
    for s in self.setIntervals {
      res.append("\(s), ")
    }
    res.removeLast(2)
    res.append("}")
    return res
  }
}
