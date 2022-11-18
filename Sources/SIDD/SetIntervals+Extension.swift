extension SetIntervals: CustomStringConvertible {
  public var description: String {
    if let set = self.setIntervals {
      var res: String = "{"
      for s in set {
        res.append("\(s), ")
      }
      res.removeLast(2)
      res.append("}")
      return res
    }
    return "nil"
  }
}
