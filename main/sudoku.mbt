/// SquareMap
struct SquareMap[T] {
  contents : Array[T]
}
// A1 => 0, A2 => 1
fn square_to_int(s : String) -> Int {
  if s[0].in('A', 'I') && s[1].in('1', '9') {
    let row = s[0].to_int() - 65 // 'A' <=> 0
    let col = s[1].to_int() - 49 // '1' <=> 0
    return row * 9 + col
  } else {
    abort("square_to_int(): \(s) is not a square")
  }
}

fn contains[T](self : SquareMap[T], pred : (T) -> Bool) -> Bool {
  var result = false
  var i = 0
  while i < self.contents.length() {
    result = result || pred(self.contents[i])
    if result {
      break
    } else {
      i = i + 1
    }
  }
  return result
}

fn SquareMap::new[T](val : T) -> SquareMap[T] {
  { contents : Array::make(81, val) }
}

fn copy[T](self : SquareMap[T]) -> SquareMap[T] {
  let arr = Array::make(81, self.contents[0])
  var i = 0
  while i < 81 {
    arr[i] = self.contents[i]
    i = i + 1
  }
  return { contents : arr }
}
  
fn op_get[T](self : SquareMap[T], square : String) -> T {
  self.contents[square_to_int(square)]
}

fn op_set[T](self : SquareMap[T], square : String, x : T) {
  self.contents[square_to_int(square)] = x
}

// 计算squares,units和peers

let rows = "ABCDEFGHI"
let cols = "123456789"

fn cross(x : String, y : String, pred : (String) -> Bool) -> List[String] {
  var result : List[String] = Nil
  var i = 0
  var j = 0
  while i < x.length() {
    while j < y.length() {
      let res = x[i].to_string() + y[j].to_string()
      if pred(res) { result = Cons(res, result)}
      j = j + 1
    }
    j = 0
    i = i + 1
  }
  return result
}

fn squares_() -> List[String] {
  cross(rows, cols, fn (__){ true })
}

let squares : List[String] = squares_().reverse()

fn unitOf(square : String) -> List[String] {
  let row = square[0]
  let col = square[1]
  var rows = ""
  var cols = ""
  if row.in('A', 'C') {
    rows = "ABC"
  }
  if row.in('D', 'F') {
    rows = "DEF"
  }
  if row.in('G', 'I') {
    rows = "GHI"
  }
  if col.in('1', '3') {
    cols = "123"
  }
  if col.in('4', '6') {
    cols = "456"
  }
  if col.in('7', '9') {
    cols = "789"
  }
  cross(rows, cols, fn (s){ s != square })
}

fn newUnitTable() -> SquareMap[List[String]] {
  let table : SquareMap[List[String]] = SquareMap::new(Nil)
  squares.iter(fn (square) {
    table[square] = unitOf(square)
  })
  table
}

let units : SquareMap[List[String]] = newUnitTable()

fn isPeerOf(self : String, square : String) -> Bool {
  self != square && (self[0] == square[0] || self[1] == square[1] || units[square].exist(fn (sq) { sq == self }))
}

fn newPeers() -> SquareMap[List[String]] {
  let table : SquareMap[List[String]] = SquareMap::new(Nil)
  squares.iter(fn (square) {
    table[square] = squares.filter(fn (sq) { sq.isPeerOf(square) })
  })
  return table
}

let peers : SquareMap[List[String]] = newPeers()


// Grid

fn eliminate(values : SquareMap[List[Char]], key : String, val : Char) -> Bool {
  if not(values[key].exist(fn (v) { v == val })) {
    return true
  }
  values[key] = values[key].remove(val)
  // 如果key对应的可能性只剩下一种，则从key的邻近位置中消除此可能性
  match values[key].single() {
    Err(b) => {
      if not(b) {
        return false
      }
    }
    Ok(val) => {
      var result = true
      peers[key].iter(fn (key) {
        result = result && eliminate(values, key, val)
      })
      if not(result) {
        return false
      }
    }
  }
  // 如果key所在的unit中只剩下一个方块可容纳val, 则把val赋值给该方块
  let unit = units[key]
  let places = unit.filter(fn (sq) {
    values[sq].exist(fn (v) { v == val })
  })
  match places.single() {
    Err(b) => {
      if not(b) {
        return false
      }
    }
    Ok(key) => {
      return assign(values, key, val)
    }
  }
  return true
}

fn assign(values : SquareMap[List[Char]], key : String, val : Char) -> Bool {
  let other_values = values[key].remove(val)
  var result = true
  other_values.iter(fn (val) {
    result = result && eliminate(values, key, val)
  })
  return result
}


fn parseGrid(s : String) -> SquareMap[List[Char]] {
  let values : SquareMap[List[Char]] = SquareMap::new(Nil)
  let digits = cols.to_list()
  // 初始化values
  squares.iter(fn (square){
    values[square] = digits
  })
  let chars = s.to_list().filter(fn (ch){
    ch.in('0', '9') || ch == '.'
  })
  var pairs = zip(squares, chars)
  while not(pairs.isNil()) {
    let Cons(p, ps) = pairs
    let (square, digit) = p
    if digit.in('1', '9') {
      if not(assign(values, square, digit)) {
        abort("parseGrid(): found contradiction")
      }
    }
    pairs = ps
  }
  return values
}

fn printGrid(grid : SquareMap[List[Char]]) {
  let rep = Array::make(81, "")
  var i = 0
  var maxWidth = 0
  while i < 81 {
    rep[i] = string(grid.contents[i])
    maxWidth = max(rep[i].length(), maxWidth)
    i = i + 1
  }
  i = 0
  while i < 81 {
    print(" ")
    print(rep[i])
    print(blank(maxWidth - rep[i].length()))
    if (i + 1) % 27 == 0 && i + 1 != 81 {
      print("\n")
      print(String::make(maxWidth * 3 + 6, '-'))
      print("+")
      print(String::make(maxWidth * 3 + 6, '-'))
      print("+")
      print(String::make(maxWidth * 3 + 6, '-'))
      print("\n")
    } else if (i + 1) % 9 == 0 {
      print("\n")
    } else if (i + 1) % 3 == 0 {
      print(" |")
    } else {
      print(" ")
    }
    i = i + 1
  }
}

fn search(values : SquareMap[List[Char]]) -> Option[SquareMap[List[Char]]] {
  if values.contains(fn (digits){ not(digits.isSingleton()) }) {
    var minsq = ""
    var n = 10
    squares.iter(fn (sq) {
      let len = values[sq].length()
      if len > 1 {
        if len < n {
          n = len
          minsq = sq
        }
      }
    })
    var result : Option[SquareMap[List[Char]]] = None
    values[minsq].iter_if(fn (digit) {
      let another = values.copy()
      if assign(another, minsq, digit) {
        let temp = search(another)
        match temp {
          None => true
          Some(v) => {
            result = Some(v)
            false
          }
        }
      } else {
        true
      }
    })
    return result
  } else {
    return Some(values)
  }
}

fn solve(g : String) -> SquareMap[List[Char]] {
  match search(parseGrid(g)) {
    None => abort("solve() : cant solve \(g)")
    Some(v) => v
  }
}