fn in(self : Char, lw : Char, up : Char) -> Bool {
  self >= lw && self <= up
}

fn remove[T : Eq](self : List[T], elem : T) -> List[T] {
  fn go(lst : List[T]) -> List[T] {
    match lst {
      Nil => Nil
      Cons(x, xs) => {
        if x == elem {
          go(xs)
        } else {
          Cons(x, go(xs))
        }
      }
    }
  }
  go(self)
}

fn iter[X](self: List[X], f: (X) -> Unit) -> Unit {
  match self {
    Nil => ()
    Cons(x, rest) => { f(x); iter(rest, f) }
  }
}

fn to_string[T : Show](self : List[T]) -> String {
  fn go(ls : List[T]){
    match ls {
      Nil => ""
      Cons(x,Nil) => "\(x)"
      Cons(x,xs) => "\(x), " + go(xs)
    }
  }
  "[" + go(self) + "]"
}

fn to_string[T : Show](self : Option[T]) -> String {
  match self {
    None => "None"
    Some(v) => "Some(\(v))"
  }
}

// fn to_string[X : Show, Y : Show](self : (X, Y)) -> String {
//   let (x, y) = self
//   "(\(x), \(y))"
// }

fn concat[X](self: List[X], ys: List[X]) -> List[X] {
  match self {
    Nil => ys
    Cons(x, rest) => Cons(x, concat(rest, ys))
  }
}

fn exist[T](self : List[T], pred : (T) -> Bool) -> Bool {
  match self {
    Nil => false
    Cons(x, xs) => pred(x) || exist(xs, pred)
  }
}

fn filter[T](self: List[T], predicate: (T) -> Bool) -> List[T] {
  match self {
    Nil => Nil
    Cons(x, xs) =>
      if predicate(x) {
        Cons(x, filter(xs, predicate))
      } else {
        filter(xs, predicate)
      }
  }
}

fn to_list(self : String) -> List[Char] {
  fn go(i : Int) -> List[Char] {
    if i < self.length() {
      Cons(self[i], go(i + 1))
    } else {
      Nil
    }
  }
  go(0)
}

fn zip[X, Y](xs : List[X], ys : List[Y]) -> List[(X, Y)] {
  match (xs, ys) {
    (Nil, Nil) => Nil
    (Cons(x, xs), Cons(y, ys)) => {
      Cons((x, y), zip(xs, ys))
    }
    _ => abort("zip(): length xs != length ys")
  }
}


fn isNil[T](self : List[T]) -> Bool {
  match self {
    Nil => true
    _   => false
  }
}

fn string(lst : List[Char]) -> String {
  match lst {
    Nil => ""
    Cons(x, xs) => x.to_string() + string(xs)
  }
}

fn blank(n : Int) -> String {
  // String::make(n, ' ')
  fn go(i : Int) -> String {
    if i == 0 {
      return ""
    } else {
      " " + go(i - 1)
    }
  }
  go(n)
}

fn max(x : Int, y : Int) -> Int {
  if x < y {
    y
  } else {
    x
  }
}

fn reverse[X](self: List[X]) -> List[X] {
  fn go(acc, xs: List[X]) {
    match xs {
      Nil => acc
      Cons(x, rest) => go((Cons(x, acc) : List[X]), rest)
    }
  }

  go(Nil, self)
}

fn all[T](self : List[T], pred : (T) -> Bool) -> Bool {
  match self {
    Nil => true
    Cons(x, xs) => pred(x) && all(xs, pred)
  }
}

fn String::make(n : Int, ch : Char) -> String {
    fn go(i : Int) -> String {
    if i == 0 {
      return ""
    } else {
      ch.to_string() + go(i - 1)
    }
  }
  go(n)
}

enum Result[V, E] {
  Ok(V)
  Err(E)
}

fn single[T](self : List[T]) -> Result[T, Bool] {
  match self {
    Nil => Err(false)
    Cons(x, Nil) => Ok(x)
    _ => Err(true)
  }
}