///|
pub fn init_values() -> Grid[@immut/sorted_set.T[Char]] {
  let digits = @immut/sorted_set.from_array(cols.to_array())
  Grid::new(digits)
}

///|
pub fn solve_values(
  values : Grid[@immut/sorted_set.T[Char]]
) -> Grid[@immut/sorted_set.T[Char]] {
  match search(values) {
    None => abort("solve() : cant solve")
    Some(v) => v
  }
}

///|
pub fn ij_assign(
  values : Grid[@immut/sorted_set.T[Char]],
  i : Int,
  j : Int,
  val : Int
) -> Bool {
  let key = "\{Int::unsafe_to_char(rows.charcode_at(i))}\{Int::unsafe_to_char(cols.charcode_at(j))}"
  let val = Int::unsafe_to_char(val.to_string().charcode_at(0))
  assign(values, key, val)
}

///|
pub fn ij_read(
  values : Grid[@immut/sorted_set.T[Char]],
  i : Int,
  j : Int
) -> Int {
  let key = "\{Int::unsafe_to_char(rows.charcode_at(i))}\{Int::unsafe_to_char(cols.charcode_at(j))}"
  let digit = values[key].min()
  digit.to_int() - 48
}
