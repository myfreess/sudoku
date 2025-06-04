///|
let rows = "ABCDEFGHI"

///|
let cols = "123456789"

///|
typealias Squares = @immut/sorted_set.T[String]

///|
fn cross(x : String, y : String, pred : (String) -> Bool) -> Squares {
  let mut result = @immut/sorted_set.new()
  for chx in x {
    for chy in y {
      let res = chx.to_string() + chy.to_string()
      if pred(res) {
        result = result.add(res)
      }
    }
  }
  return result
}

///|
let squares : Squares = cross(rows, cols, fn { _ => true })

///|
fn unit_of(square : String) -> Squares {
  let row = square.charcode_at(0)
  let col = square.charcode_at(1)
  let rows = match row {
    'A'..='C' => "ABC"
    'D'..='F' => "DEF"
    'G'..='I' => "GHI"
    _ => abort("unitOf: invalid row \{row}")
  }
  let cols = match col {
    '1'..='3' => "123"
    '4'..='6' => "456"
    '7'..='9' => "789"
    _ => abort("unitOf: invalid col \{col}")
  }
  cross(rows, cols, fn { s => s != square })
}

///|
let units : Grid[Squares] = {
  let table = Grid::new(@immut/sorted_set.new())
  for square in squares {
    table[square] = unit_of(square)
  }
  table
}

///|
test {
  inspect(
    units["A1"].to_array(),
    content=
      #|["A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"]
    ,
  )
}

///|
fn is_peer(this : String, other : String) -> Bool {
  this != other &&
  (
    this.charcode_at(0) == other.charcode_at(0) ||
    this.charcode_at(1) == other.charcode_at(1) ||
    units[other].contains(this)
  )
}

///|
let peers : Grid[Squares] = {
  let table = Grid::new(@immut/sorted_set.new())
  for square in squares {
    table[square] = squares.filter(fn(sq) { is_peer(sq, square) })
  }
  table
}
