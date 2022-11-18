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

//extension Lbracket: CustomStringConvertible {
//  public var description: String {
//    switch self {
//    case .e:
//      return "("
//    case .i:
//      return "["
//    }
//  }
//}
//
//extension Rbracket: CustomStringConvertible {
//  public var description: String {
//    switch self {
//    case .e:
//      return ")"
//    case .i:
//      return "]"
//    }
//  }
//}
//
//extension Interval: CustomStringConvertible {
//  public var description: String {
//    switch self {
//    case .empty:
//      return "Ø"
//    case .intvl(lbracket: let l, a: let a, b: let b, rbracket: let r):
//      return "\(l)\(a),\(b)\(r)"
//    }
//  }
//}
