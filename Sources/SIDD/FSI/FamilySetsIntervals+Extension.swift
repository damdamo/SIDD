extension FamilySetsIntervals: CustomStringConvertible {
  public var description: String {
    if self.familySetsIntervals == [] {
      return "{}"
    }
    var res: String = "{"
    for s in self.familySetsIntervals {
      res.append("\(s), ")
    }
    res.removeLast(2)
    res.append("}")
    return res
  }
}
