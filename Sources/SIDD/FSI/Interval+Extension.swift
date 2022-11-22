// Pprint for intervals
extension Interval: CustomStringConvertible {
  public var description: String {
    var res: String = ""
    switch self.intvl {
    case .empty:
      res = "Ø"
    case .intvl(lbracket: let l, a: let a, b: let b, rbracket: let r):
      switch l {
      case .e:
        res.append("(")
      case .i:
        res.append("[")
      }
      res.append("\(a),\(b)")
      switch r {
      case .e:
        res.append(")")
      case .i:
        res.append("]")
      }
    default:
      return ""
    }
    return res
  }
}
