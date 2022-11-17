extension Lbracket: CustomStringConvertible {
  public var description: String {
    switch self {
    case .e:
      return "("
    case .i:
      return "["
    }
  }
}

extension Rbracket: CustomStringConvertible {
  public var description: String {
    switch self {
    case .e:
      return ")"
    case .i:
      return "]"
    }
  }
}

extension Interval: CustomStringConvertible {
  public var description: String {
    switch self {
    case .empty:
      return "Ø"
    case .intvl(lbracket: let l, a: let a, b: let b, rbracket: let r):
      return "\(l)\(a),\(b)\(r)"
    }
  }
}
