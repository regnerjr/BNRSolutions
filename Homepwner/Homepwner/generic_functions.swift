import Foundation

//Define fmap
infix operator <^> {associativity left}

func <^><A,B>(f:A -> B, a: A?) -> B? {
  switch a {
  case .Some(let x): return f(x)
  case .None: return .None
  }
}

//Define apply
infix operator <*> {associativity left}
func <*><A,B>(f:(A -> B)?, a: A?) -> B? {
  switch f {
  case .Some(let fx): return fx <^> a
  case .None: return .None
  }
}

//Define Bind for Optionals
infix operator >>=- {associativity left}
func >>=-<A,B>(a: A?, f: A -> B?) -> B? {
  switch a {
    case .Some (let x) : return f(x)
    case .None : return nil
  }
}