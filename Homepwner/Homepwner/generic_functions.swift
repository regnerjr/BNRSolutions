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

func randomNumberLessThan(maxNumber: Int) -> Int {
  //this hack is here because without it this crashes on 32 bit architecture. 😢
  return Int(arc4random() & 0x7FFF_FFFF ) % maxNumber //mask off top bit
}
