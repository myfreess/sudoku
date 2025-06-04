///|
type Grid[T] FixedArray[T]

///|
fn[T] Grid::new(val : T) -> Grid[T] {
  FixedArray::make(81, val)
}

///|
fn[T] Grid::copy(self : Grid[T]) -> Grid[T] {
  if self._.length() == 0 {
    return []
  }
  let arr = FixedArray::make(81, self._[0])
  let mut i = 0
  while i < 81 {
    arr[i] = self._[i]
    i = i + 1
  }
  return arr
}

///|
fn square_to_int(s : String) -> Int {
  if s.charcode_at(0) is ('A'..='I') && s.charcode_at(1) is ('1'..='9') {
    let row = s.charcode_at(0) - 65 // 'A' <=> 0
    let col = s.charcode_at(1) - 49 // '1' <=> 0
    return row * 9 + col
  } else {
    abort("Grid_to_int(): \{s} is not a Grid")
  }
}

///|
test {
  inspect(square_to_int("A1"), content="0")
  inspect(square_to_int("A7"), content="6")
  inspect(square_to_int("I9"), content="80")
}

///|
fn[T] Grid::op_get(self : Grid[T], square : String) -> T {
  let i = square_to_int(square)
  self._[i]
}

///|
fn[T] Grid::op_set(self : Grid[T], square : String, x : T) -> Unit {
  let i = square_to_int(square)
  self._[i] = x
}

///|
fn[T] Grid::contains(self : Grid[T], pred : (T) -> Bool) -> Bool {
  let mut result = false
  for i = 0; i < self._.length(); i = i + 1 {
    result = result || pred(self._[i])
    if result {
      break
    }
  }
  return result
}
